extends CharacterBody2D
class_name PlayerController
enum PlayerState { Idle, Moving, Casting, Fishing, Reeling }
const DIRECTIONAL_ARROW = preload("res://Scenes/directional_arrow.tscn")

#Upgradeable
var bobbersList: Array[PackedScene] = [
	preload("res://Scenes/Bobbers/Pluto.tscn")
]
@export var maxMovementSpeed: float
@export var acceleration: float
@export var friction: float
@export var maxCastPower: float

@export var aimArrow: Sprite2D
@export var sprite: AnimatedSprite2D
@export var vboxContainer: VBoxContainer
@export var planetParent: Node2D
@export var castDistance: float = 150.0
@export var fishingLineMarker: Marker2D


var playerState: PlayerState = PlayerState.Idle
var characterDirection: Vector2
var castPower: float = 0.0
var arrows: Array[DirectionalArrow] = []
var fishList: Array[Fish] = []
var activeBobbers: Array[Bobber] = []
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("CastReel"):
		castPower += delta
	print(PlayerState.find_key(playerState))
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
	#print(aimArrow.rotation)
	
func _physics_process(delta: float) -> void:
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
	elif characterDirection.x < 0:
		sprite.flip_h = false

	# Smooth acceleration and deceleration
	if characterDirection != Vector2.ZERO:
		var target_velocity = characterDirection * maxMovementSpeed
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()

	# Prevent velocity from building up against walls
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()

		if velocity.dot(normal) < 0:
			velocity = velocity.slide(normal)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_released("CastReel") && playerState == PlayerState.Casting:
		print("Total hold duration was: ", min(castPower, maxCastPower)) 
		if min(castPower, maxCastPower) < 0.5:
			EndFishing()
			castPower = 0.0
			return
		playerState = PlayerState.Fishing #the time spent waiting for fish
		CastBobbers(min(castPower, maxCastPower))
		castPower = 0.0 
	elif event.is_action_pressed("CastReel"):
		if playerState == PlayerState.Idle || playerState == PlayerState.Moving:
				playerState = PlayerState.Casting
		elif playerState == PlayerState.Fishing:
			playerState = PlayerState.Reeling
			StartReelingMinigame()
	elif playerState == PlayerState.Reeling:
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
		arrows.pop_front()
		arrow.queue_free()

		if arrows.is_empty():
			print("Combo complete!")
			EndFishing()
	else:
		EndFishing()

func CastBobbers(castPower: float) -> void:
	aimArrow.hide()

	var cast_direction: Vector2 = Vector2.RIGHT.rotated(aimArrow.global_rotation)

	for bobberScene in bobbersList:
		var bobber: Bobber = bobberScene.instantiate()

		planetParent.add_child(bobber)
		bobber.global_position = global_position

		# Cast the bobber in the aiming direction
		#bobber.cast(cast_direction, castPower)
		# draw line connecting fishing rod marker and planet

		activeBobbers.append(bobber)
		print(bobber.getBobberName())

func StartReelingMinigame() -> void:
	for activeBobber in activeBobbers:
		fishList.append_array(activeBobber.reelIn())
		
	if fishList.size() == 0:
		EndFishing()
		return
	var comboLength = 4 + fishList.size() - 1
	
	for i in comboLength:
		var arrow_instance = DIRECTIONAL_ARROW.instantiate()
		arrows.append(arrow_instance)
		vboxContainer.add_child(arrow_instance)

func EndFishing() -> void:
	playerState = PlayerState.Idle
	for child in vboxContainer.get_children():
		arrows.pop_front()
		child.queue_free()	
	for child in planetParent.get_children():
		activeBobbers.pop_front()
		child.queue_free()
	aimArrow.show()
	
func DrawFishingLines() -> void:
	print("Hi")
