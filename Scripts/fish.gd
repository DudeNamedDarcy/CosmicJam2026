extends Node2D
class_name Fish

enum State { IDLE, ORBITING }

@export var typeName: String = "default"
@export var value: float = 0.0
@export var orbitManager: OrbitManager

var state: State
var center: Node2D
var inCatchRadius: bool

func _ready() -> void:
	if !orbitManager:
		printerr("No orbit manager assigned!")
	state = State.IDLE
	center = null
	inCatchRadius = false

func _process(delta: float) -> void:
	match state:
		State.IDLE:
			handleIdle(delta)
		State.ORBITING:
			handleOrbit(delta)
	
func handleIdle(delta: float):
	pass
	
func handleOrbit(delta:float):
	if center == null:
		return

	var to_center: Vector2 = (
		center.global_position - global_position
	)

	var distance: float = to_center.length()

	if distance < 0.001:
		return

	var inward: Vector2 = to_center / distance
	var tangent: Vector2 = Vector2(-inward.y, inward.x)

	# Positive = move inward.
	# Negative = move outward.
	var radial_speed: float

	if distance > orbitManager.orbit_radius * 3.0:
		radial_speed = minf(
			(distance - orbitManager.orbit_radius) * orbitManager.radial_gain,
			45.0
		)
	else:
		radial_speed = minf(
			(distance - orbitManager.orbit_radius) * 5.0,
			orbitManager.max_inward_speed
		)

	radial_speed = maxf(radial_speed, -orbitManager.max_outward_speed)

	var closeness: float = 1.0 - clampf(
		distance / orbitManager.swirl_range,
		0.0,
		1.0
	)

	var swirl_speed: float = lerpf(
		orbitManager.outer_swirl_speed,
		orbitManager.inner_swirl_speed,
		closeness
	)

	var movement: Vector2 = (
		inward * radial_speed
		+ tangent * swirl_speed
	)

	global_position += movement * delta


func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.is_in_group("Bobbers")):
		center = area
		state = State.ORBITING
		
func setInCatchRadius(val: bool):
	inCatchRadius = val
	self.modulate = Color.RED
	
func getInCatchRadius() -> bool:
	return inCatchRadius
