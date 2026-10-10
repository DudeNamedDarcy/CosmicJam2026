extends Line2D

@export var playerController: Node # Changed to Node or CharacterBody2D if PlayerController gives a type error
@export var startPoint: Vector2

@export var end_point: Vector2 = Vector2(400, 200)
@export var sag: float = 100.0
@export_range(4, 100) var segments: int = 32

# Cache a reference to the marker so we don't have to call get_node() every single frame
var marker: Marker2D 

func _ready() -> void:
	playerController = get_tree().get_first_node_in_group("PlayerController")
	
	# Safely find and store the marker reference once at the start
	if playerController:
		marker = playerController.get_node("Marker2D")
	
func _process(_delta: float) -> void:
	# 1. Update the position every frame if the marker exists
	if is_instance_valid(marker):
		startPoint = marker.position

	clear_points()

	for i in range(segments + 1):
		var t = float(i) / segments

		# 2. Fixed the typo: using startPoint instead of start_point
		var point = startPoint.lerp(end_point, t)

		# Add downward sag, strongest in the middle
		point.y += 4.0 * sag * t * (1.0 - t)

		# 3. Convert global positions back to the Line2D's local space
		add_point(to_local(point))
