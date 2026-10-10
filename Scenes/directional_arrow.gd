extends Control
class_name DirectionalArrow

enum ArrowType { Up, Right, Down, Left }
@onready var texture_rect: TextureRect = $TextureRect


@export var arrows: Array[Texture] = []

var arrowType: ArrowType

func GetArrowType() -> ArrowType:
	return arrowType
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	arrowType = randi_range(0, 3)
	texture_rect.texture = arrows[0]
	texture_rect.rotation_degrees = arrowType*90
