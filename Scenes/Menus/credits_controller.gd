extends Label
var velocity: Vector2 = Vector2(0, -30) # Set your speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	position += velocity * delta
