extends CharacterBody2D
enum PlayerState { Idle, Moving, Casting, Fishing, Reeling }

@export var sprite: Sprite2D
@export var maxMovementSpeed: float = 150.0
@export var acceleration: float = 400.0
@export var friction: float = 600.0
var playerState: PlayerState = PlayerState.Idle
var characterDirection: Vector2
var holdDuration: float = 0.0

func _process(delta: float) -> void:
	if Input.is_action_pressed("CastReel"):
		holdDuration += delta
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
		print("Total hold duration was: ", holdDuration) 
		playerState = PlayerState.Fishing #the time spent waiting for fish
		holdDuration = 0.0 
		
	if event.is_action_pressed("CastReel"):
		if playerState == PlayerState.Idle || playerState == PlayerState.Moving:
				playerState = PlayerState.Casting #allow player to choose direction then strength
		elif playerState == PlayerState.Fishing:
			playerState = PlayerState.Reeling #the time spent comboing
	
	
