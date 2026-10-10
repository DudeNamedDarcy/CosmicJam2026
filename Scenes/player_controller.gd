extends CharacterBody2D

@export var sprite: Sprite2D
@export var maxMovementSpeed: float
@export var acceleration: float
@export var friction: float

var isFishing: bool

var characterDirection: Vector2

func _physics_process(delta: float) -> void:
	if isFishing:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta * 3)
		move_and_slide()
		return
		
	characterDirection.x = Input.get_axis("MoveLeft", "MoveRight")
	characterDirection.y = Input.get_axis("MoveUp", "MoveDown")
	characterDirection = characterDirection.normalized()

	# Flip sprite TODO: add squash and stretch
	if characterDirection.x > 0:
		sprite.flip_h = true
	elif characterDirection.x < 0:
		sprite.flip_h = false

	# Accelerate in the direction of input
	if characterDirection != Vector2.ZERO:
		velocity += characterDirection.normalized() * acceleration * delta

		# Clamp maximum speed
		velocity = velocity.limit_length(maxMovementSpeed)
	else:
		# Gradually lose momentum
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()

func _input(event):
	if event.is_action_pressed("CastReel"):
		isFishing = !isFishing
		print(isFishing)
