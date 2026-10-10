extends CharacterBody2D
enum PlayerState { Idle, Moving, Casting, Fishing, Reeling }
const DIRECTIONAL_ARROW = preload("res://Scenes/directional_arrow.tscn")

#Upgradeable
@export var maxMovementSpeed: float
@export var acceleration: float
@export var friction: float
@export var maxCastPower: float

@export var sprite: Sprite2D
@export var vboxContainer: VBoxContainer
var playerState: PlayerState = PlayerState.Idle
var characterDirection: Vector2
var castPower: float = 0.0
var arrows: Array[DirectionalArrow] = []

func _process(delta: float) -> void:
	if Input.is_action_pressed("CastReel"):
		castPower += delta
	print(PlayerState.find_key(playerState))

func _physics_process(delta: float) -> void:
	characterDirection.x = Input.get_axis("MoveLeft", "MoveRight")
	characterDirection.y = Input.get_axis("MoveUp", "MoveDown")
	characterDirection = characterDirection.normalized()
	
	if playerState == PlayerState.Casting || playerState == PlayerState.Fishing || playerState == PlayerState.Reeling:
		characterDirection = Vector2.ZERO
	else:
		if characterDirection == Vector2.ZERO:
			playerState = PlayerState.Idle
		else:
			playerState = PlayerState.Moving
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
		playerState = PlayerState.Fishing #the time spent waiting for fish
		castPower = 0.0 
	elif event.is_action_pressed("CastReel"):
		if playerState == PlayerState.Idle || playerState == PlayerState.Moving:
				playerState = PlayerState.Casting
		elif playerState == PlayerState.Fishing:
			playerState = PlayerState.Reeling
			StartReelingMinigame()
	elif playerState == PlayerState.Reeling:
		if event.is_action_pressed("ComboUp"):
			print("UP")
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
	if arrows[0].GetArrowType() == input_arrow:
		var arrow = arrows.pop_front()
		Input.start_joy_vibration(0, 0.5, 0.8, .3)
		arrow.queue_free()

		if arrows.is_empty():
			print("Combo complete!")
			EndFishing()
	else:
		EndFishing()

func StartReelingMinigame() -> void:
	var numFish = randi_range(1, 5) #replace with getfish
	var comboLength = 4 + numFish - 1
	for i in comboLength:
		var arrow_instance = DIRECTIONAL_ARROW.instantiate()
		arrows.append(arrow_instance)
		vboxContainer.add_child(arrow_instance)

func EndFishing() -> void:
	playerState = PlayerState.Idle
	for child in vboxContainer.get_children():
		child.queue_free()	
