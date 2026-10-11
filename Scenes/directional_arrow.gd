extends Control
class_name DirectionalArrow

enum ArrowType { Up, Right, Down, Left }
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D



var arrowType: ArrowType

func GetArrowType() -> ArrowType:
	return arrowType
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arrowType = randi_range(0, 3)
	sprite.rotation_degrees = arrowType*90
	if sprite.rotation_degrees == 180:
		sprite.flip_h = true
	sprite.animation = "Idle"

func KillArrow() -> void:
	sprite.animation = "Die"
	await sprite.animation_finished
	queue_free()

func TurnRed(duration: float = 1.0) -> void:
	var target_color = Color.DARK_RED
	var tween = create_tween()
	tween.tween_property(self, "modulate", target_color, duration)

	
	
