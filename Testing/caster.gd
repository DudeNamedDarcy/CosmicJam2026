extends Node2D

@export var bobbersList: Array[PackedScene]
@export var castPower = 300.0
@export var castRandomSpread: float = 0.0
@export var castRandomPower: float = 0.0
@export var castDeceleration: float = 100

func _input(event):
	# Check if the event is a mouse button action
	if event is InputEventMouseButton:
		# Check if it's the left mouse button and that it was just pressed (not released)
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			CastBobbers(get_global_mouse_position())

func CastBobbers(mouse_pos: Vector2) -> void:
	var cast_direction = (mouse_pos - global_position).normalized()
	print(cast_direction)

	for bobberScene in bobbersList:
		var bobber: Bobber = bobberScene.instantiate()
		var bobberLine: Line2D = Line2D.new()
		bobberLine.width = 1

		add_child(bobber)
		add_child(bobberLine)
		bobber.global_position = global_position
		
		var randomAngle = randf_range(-castRandomSpread, castRandomSpread)
		var randomizedDirection = cast_direction.rotated(randomAngle)
		var randomizedPower = castPower + randf_range(-castRandomPower, castRandomPower)
		# Cast the bobber in the aiming direction
		bobber.cast(randomizedDirection, randomizedPower, castDeceleration, bobberLine)

		#activeBobbers.append(bobber)
		print(bobber.bobberType)
