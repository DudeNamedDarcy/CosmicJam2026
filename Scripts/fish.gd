extends CharacterBody2D
class_name Fish

enum State { IDLE, ORBITING }

@export_category("Fish Type Information")
@export var typeName: String = "default"
@export var value: float = 0.0
@export var orbitManager: OrbitManager
@export var fishTexture: Texture2D

@export_category("Idle Movement")
@export var IdleBurstTimer: Timer
@export var idleBurstSpeed = 100.0
@export var maxCooldownTime = 3.0
@export var deceleration = 50

var idleBurstDirection: Vector2
var idleBurstDistance: float
var inActiveBurst: bool = false
var inCooldown: bool = false
var idleSpeed: float

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
	if inCooldown:
		return

	if not inActiveBurst:
		idleSpeed = idleBurstSpeed
		startBurst()
	else:
		velocity = idleBurstDirection * idleSpeed
		idleSpeed = move_toward(idleSpeed, 0, deceleration * delta)

		var collision = move_and_collide(velocity * delta)

		if collision:
			idleBurstDirection = idleBurstDirection.bounce(
				collision.get_normal()
			).normalized()

		if idleSpeed <= 0.0:
			inActiveBurst = false
			inCooldown = true
			var cooldown = randf_range(1.0, maxCooldownTime)
			IdleBurstTimer.start(cooldown)
			
func startBurst():
	idleBurstDirection = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	inActiveBurst = true
	
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

func _on_idle_burst_timer_timeout() -> void:
	inCooldown = false
