extends CharacterBody2D

@export var sprite: Sprite2D
@export var maxMovementSpeed: float = 150.0
@export var acceleration: float = 400.0
@export var friction: float = 600.0

var isFishing: bool
var characterDirection: Vector2

func _physics_process(delta: float) -> void:
	characterDirection.x = Input.get_axis("MoveLeft", "MoveRight")
	characterDirection.y = Input.get_axis("MoveUp", "MoveDown")
	characterDirection = characterDirection.normalized()

	if isFishing:
		characterDirection = Vector2.ZERO

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
	if event.is_action_pressed("CastReel"):
		isFishing = !isFishing
		print(isFishing)
