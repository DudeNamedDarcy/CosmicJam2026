extends CharacterBody2D
class_name PlayerController
enum PlayerState { Idle, Moving, Casting, Fishing, Reeling }
const DIRECTIONAL_ARROW = preload("res://Scenes/directional_arrow.tscn")
const COMBO_FISH = preload("res://Scenes/Fish/fish_combo_sprite.tscn")
const MONEY_GAIN_TEXT = preload("res://Scenes/fish_money_text.tscn")

#Upgradeable
var bobbersList: Array[PackedScene] = [
	preload("res://Scenes/Bobbers/Pluto.tscn"),
	#preload("res://Scenes/Bobbers/Mercury.tscn"),
	#preload("res://Scenes/Bobbers/Venus.tscn"),
	#preload("res://Scenes/Bobbers/Earth.tscn"),
	#preload("res://Scenes/Bobbers/Mars.tscn"),
	#preload("res://Scenes/Bobbers/Neptune.tscn"),
	#preload("res://Scenes/Bobbers/Uranus.tscn"),
	#preload("res://Scenes/Bobbers/Saturn.tscn"),
	preload("res://Scenes/Bobbers/Jupiter.tscn")
]
@export_category("Movement")
@export var maxMovementSpeed: float
@export var acceleration: float
@export var friction: float

@export_category("Casting")
@export var maxCastPower: float
@export var castRandomSpread: float = 0.0
@export var castRandomPower: float = 0.0
@export var castDeceleration: float = 100
var castPower: float = 0.0

@export_category("References")
@export var aimArrow: Sprite2D
@export var sprite: AnimatedSprite2D
@export var vboxContainer: VBoxContainer
@export var moneyVboxContainer: VBoxContainer
@export var planetParent: Node2D
@export var fishSpawner: FishSpawner
@export var castingPointLeft: Marker2D
@export var castingPointRight: Marker2D

@onready var area_2d: Area2D = $Area2D
@onready var uiController = get_node("/root/GameScene/MoneyFuelUI")

var playerState: PlayerState = PlayerState.Idle
var characterDirection: Vector2
var arrows: Array[DirectionalArrow] = []
var fishList: Array[Fish] = []
var activeBobbers: Array[Bobber] = []

@onready var boat_audio: AudioStreamPlayer2D = $BoatNoise
@onready var rod_audio: AudioStreamPlayer2D = $RodNoise
var comboFishList: Array[FishComboSprite] = []
var aim_arrow_base_scale: float
var castingPoint: Marker2D

#Market
@export var black_hole_market: CanvasLayer

@onready var input_button: AnimatedSprite2D = $InputButton

# Quest
var fishNeededForQuest: String = ""
var caughtFishForQuest = false

var elapsedComboTime: float
@export var maxComboTime: float = 1.0
var comboSize: float
func _ready() -> void:
	aim_arrow_base_scale = aimArrow.scale.x
	input_button.visible = false
	area_2d.name = "starship"
	castingPoint = castingPointLeft
	uiController.UpdateMoneyText()
	uiController.UpdateFuelText()


func _process(delta: float) -> void:
	if playerState == PlayerState.Reeling:
		elapsedComboTime += delta
		if elapsedComboTime >= maxComboTime:
			EndFishing(false)
			elapsedComboTime = 0.0
	if Input.is_action_pressed("CastReel"):
		castPower += delta
	var charge_ratio: float = 0.0
	if maxCastPower > 0.0:
		charge_ratio = clamp(castPower / maxCastPower, 0.0, 1.0)

	aimArrow.scale = Vector2(aim_arrow_base_scale * (1.0 + charge_ratio), aim_arrow_base_scale * (1.0 + charge_ratio))
	AimMouse()
		

func AimMouse() -> void:
	# Mouse aiming
	var mouse_direction = get_global_mouse_position() - global_position

	# Right joystick aiming
	var joy_direction = Vector2(Input.get_joy_axis(0, JOY_AXIS_RIGHT_X), Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y))

	# Use the joystick when it's being moved; otherwise use the mouse
	if joy_direction.length() > 0.2:
		aimArrow.rotation = joy_direction.angle()
	else:
		aimArrow.rotation = mouse_direction.angle()
	
func _physics_process(delta: float) -> void:
	maxComboTime = (ScoreAndUpgrades.longer_combo_progress + 1)
	uiController.UpdateFuelText()
	#thanks to this article: https://forum.godotengine.org/t/how-to-display-a-float-with-two-decimal-points/133086/3
	characterDirection.x = Input.get_axis("MoveLeft", "MoveRight")
	characterDirection.y = Input.get_axis("MoveUp", "MoveDown")
	characterDirection = characterDirection.normalized()
	
	if playerState == PlayerState.Casting || playerState == PlayerState.Fishing || playerState == PlayerState.Reeling:
		characterDirection = Vector2.ZERO
	else:
		if characterDirection == Vector2.ZERO:
			playerState = PlayerState.Idle
			sprite.animation = "Idle"
		else:
			playerState = PlayerState.Moving
			sprite.animation = "Move"

	# Flip sprite TODO: Add squash and stretch
	if characterDirection.x > 0:
		sprite.flip_h = true
		castingPoint = castingPointRight
	elif characterDirection.x < 0:
		sprite.flip_h = false
		castingPoint = castingPointLeft

	# Smooth acceleration and deceleration
	if characterDirection != Vector2.ZERO:
		boat_audio.accelerating()
		ScoreAndUpgrades.fuel_quantity -= 0.075
		var target_velocity = characterDirection * (maxMovementSpeed + (50 * (ScoreAndUpgrades.faster_ship_progress)))
		velocity = velocity.move_toward(target_velocity, (acceleration + (50 * (ScoreAndUpgrades.faster_ship_progress))) * delta)
	else:
		boat_audio.decelerating()
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()

	# Prevent velocity from building up against walls
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()

		if velocity.dot(normal) < 0:
			velocity = velocity.slide(normal)
	
func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		input_button.play("A_button")
	else:
		input_button.play("E_button")

	if Input.is_action_just_released("CastReel") && playerState == PlayerState.Casting:
		rod_audio.stop_reeling()
		rod_audio.throwing()
		#print("Total hold duration was: ", min(castPower, maxCastPower)) 
		if min(castPower, maxCastPower) < 0.3:
			EndFishing(false)
			castPower = 0.0
			return
		playerState = PlayerState.Fishing #the time spent waiting for fish
		CastBobbers(min(castPower, maxCastPower))
		castPower = 0.0 
	elif event.is_action_pressed("CastReel"):
		#if(playerState == PlayerState.Reeling):
		rod_audio.reeling(maxCastPower)			
		if playerState == PlayerState.Idle || playerState == PlayerState.Moving:
				playerState = PlayerState.Casting
		elif playerState == PlayerState.Fishing:
			playerState = PlayerState.Reeling
			StartReelingMinigame()
	elif playerState == PlayerState.Reeling:
		rod_audio.stop_reeling()
		if event.is_action_pressed("ComboUp"):
			CheckArrow(DirectionalArrow.ArrowType.Up)
		elif event.is_action_pressed("ComboRight"):
			CheckArrow(DirectionalArrow.ArrowType.Right)
		elif event.is_action_pressed("ComboDown"):
			CheckArrow(DirectionalArrow.ArrowType.Down)
		elif event.is_action_pressed("ComboLeft"):
			CheckArrow(DirectionalArrow.ArrowType.Left)

func CheckArrow(input_arrow: DirectionalArrow.ArrowType) -> void:
	if arrows.is_empty():
		return

	var arrow = arrows[0]

	if not is_instance_valid(arrow):
		arrows.pop_front()
		return

	if arrow.GetArrowType() == input_arrow:
		LevelManager.shakeCamera(2.0)
		rod_audio.comboing()
		arrows.pop_front()
		arrow.KillArrow()
		comboSize += 1

		if arrows.is_empty():
			LevelManager.shakeCamera(2.0)
			#print("Combo complete! Combo size", comboSize)
			EndFishing(true)
		else:
			arrows[0].TurnRed((ScoreAndUpgrades.longer_combo_progress) + 1)
		elapsedComboTime = 0.0

	else:
		LevelManager.shakeCamera(7.0)
		rod_audio.losing()
		EndFishing(false)

func CastBobbers(castPower: float) -> void:
	aimArrow.hide()
	aimArrow.scale = Vector2(aim_arrow_base_scale, aim_arrow_base_scale)

	var cast_direction: Vector2 = Vector2.RIGHT.rotated(aimArrow.global_rotation).normalized()
	for bobberScene in bobbersList:
		var bobber: Bobber = bobberScene.instantiate()
		var bobberLine: Line2D = Line2D.new()
		bobberLine.width = 1

		planetParent.add_child(bobber)
		planetParent.add_child(bobberLine)
		bobber.global_position = castingPoint.global_position
		
		var randomAngle = randf_range(-castRandomSpread, castRandomSpread)
		var randomizedDirection = cast_direction.rotated(randomAngle)
		var randomizedPower = (castPower*100) + randf_range(-castRandomPower, castRandomPower)
		# Cast the bobber in the aiming direction
		bobber.cast(randomizedDirection, randomizedPower, castDeceleration, bobberLine)

		activeBobbers.append(bobber)
		#print(bobber.bobberType)
	
func StartReelingMinigame() -> void:
	rod_audio.stop_reeling()
	rod_audio.start_fishing()
	for activeBobber in activeBobbers:
		fishList.append_array(activeBobber.reelIn())
		activeBobber.killAllFish()
	if fishList.size() == 0:
		EndFishing(false)
		DeletePlanets()
		return
		
	if fishSpawner:
		fishSpawner.remove_fish_from_pool(fishList.size())
	var comboLength = 4 + fishList.size() - 1

	for i in comboLength:
		var arrow_instance = DIRECTIONAL_ARROW.instantiate()
		arrows.append(arrow_instance)
		vboxContainer.add_child(arrow_instance)
		if i == 0:
			arrows[0].TurnRed((ScoreAndUpgrades.longer_combo_progress) + 1)
	for fish in fishList:
		if fish.name == fishNeededForQuest:
			caughtFishForQuest = true
		
		var fish_instance = COMBO_FISH.instantiate()
		fish_instance.PopulateData(fish)
		comboFishList.append(fish_instance)
		vboxContainer.add_child(fish_instance)
	DeletePlanets()

func DeletePlanets() -> void:
	#delete planets
	for child in planetParent.get_children():
		child.queue_free()
	
	activeBobbers.clear()
	
func EndFishing(success: bool) -> void:
	var fishTotal = 0
	rod_audio.stop_reeling()
	playerState = PlayerState.Idle

	for arrow in arrows.duplicate():
		if is_instance_valid(arrow):
			arrow.KillArrow()
			rod_audio.losing()
	
	arrows.clear()
	if success:
		rod_audio.combo_win()
		await get_tree().create_timer(0.2).timeout 
	for fish in comboFishList.duplicate():
		#print(fish)
		if is_instance_valid(fish):
			if success:
				await get_tree().create_timer(0.2).timeout	
				var moneyText = MONEY_GAIN_TEXT.instantiate()
				rod_audio.winning()
				moneyVboxContainer.add_child(moneyText)
				var fishValueWithUpgrade = (fish.value) + ((ScoreAndUpgrades.larger_combo_progress) * ((fish.value)/5))
				moneyText.DisplayText(fishValueWithUpgrade)
				ScoreAndUpgrades.money += fishValueWithUpgrade
				fishTotal += fishValueWithUpgrade
			fish.KillFish(success)
				#fishvalue *comboSize * 1.1
			uiController.UpdateMoneyText()
			fish.KillFish(success)
	
	LevelManager.shakeCameraComboClear()
	comboFishList.clear()
	fishList.clear()
	comboSize = 0
	aimArrow.show()
	CompleteQuest()
	
func CompleteQuest():
	print("quest complete")
	caughtFishForQuest = false
	fishNeededForQuest = ""
	# start popup for next quest
	
# call this to add a new quest fish
func AddNewQuestFish(fishName: String):
	fishNeededForQuest = fishName


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "market":
		input_button.visible = true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "market":
		input_button.visible = false
