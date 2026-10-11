extends CharacterBody2D
class_name Bobber

enum State { UNCASTED, CASTING, FISHING }

@export var bobberType: String
@export var bobberTexture: Texture2D
var startingOrbitRadius: float
var startingCatchRadius: float

@export var bobberSprite: Sprite2D
@export var orbitArea: Area2D
@export var catchArea: Area2D

var orbitRadius: float
var catchRadius: float
var fishInOrbit: Array[Fish]
var caughtFish: Array[Fish]
var state: State

var castDirection: Vector2
var castPower: float
var castDeceleration: float
var castLine: Line2D

@onready var orbit_area_collision: CollisionShape2D = $"Orbit Area/OrbitAreaCollision"
@onready var catch_area_collision: CollisionShape2D = $"Catch Area/CatchAreaCollision"


func getBobberName() -> String:
	return bobberType
	
func _ready() -> void:
	startingOrbitRadius = orbit_area_collision.shape.radius 
	startingCatchRadius = catch_area_collision.shape.radius
	print(startingOrbitRadius)
	print(startingCatchRadius)
	print(ScoreAndUpgrades.orbit_radius_progress)
	orbitRadius = startingOrbitRadius + (10 * (ScoreAndUpgrades.orbit_radius_progress))
	catchRadius = startingCatchRadius + (10 * (ScoreAndUpgrades.catch_radius_progress))
	print(orbitRadius)
	print(catchRadius)
	bobberSprite.texture = bobberTexture
	orbitArea.monitoring = false
	catchArea.monitoring = false
	state = State.UNCASTED
	scale = Vector2(0,0)
	
func _process(delta: float) -> void:
	match state:
		State.UNCASTED:
			return
		State.CASTING:
			handleCasting(delta)
		State.FISHING:
			pass
	pass
	
func handleCasting(delta: float):
	castLine.add_point(position)
	velocity = castDirection * castPower
	castPower = move_toward(castPower, 0, castDeceleration * delta)
	scale

	var collision = move_and_collide(velocity * delta)

	if collision:
		castDirection = castDirection.bounce(
			collision.get_normal()
		).normalized()

	if castPower <= 0.0:
		startFishing()

func _draw() -> void:
	if state == State.FISHING:
		# Orbit Circle
		draw_circle(Vector2.ZERO, orbitRadius, Color(1,1,1,0.66), false, 3.0)
		# Catch Circle
		draw_circle(Vector2.ZERO, catchRadius, Color(1,1,1,0.33), false, 1.0)
	
# call this function to get fish in range, after calling this function, queue free bobber and fish from caller function
func reelIn() -> Array[Fish]:
	for fish in caughtFish:
		print("Fish Name: ", fish.typeName, ", Value: ", fish.value)
	return caughtFish

func killAllFish() -> void:
	for fish in caughtFish.duplicate():
		fish.KillFish()
	
func cast(direction: Vector2, power: float, deceleration: float, line: Line2D):
	castDirection = direction
	castPower = power
	castLine = line
	castDeceleration = deceleration
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 1.0)
	state = State.CASTING

func _on_orbit_area_area_entered(area: Area2D) -> void:
	if area.get_parent() is Fish:
		var fish: Fish = area.get_parent()

		register_fish_in_orbit(fish)

func _on_catch_area_entered(area: Area2D) -> void:
	if area.get_parent() is Fish:
		var fish: Fish = area.get_parent()

		register_fish_in_orbit(fish)

		if fish not in caughtFish:
			print("appending fish")
			caughtFish.append(fish)
			print(caughtFish.size())

		if not fish.inCatchRadius:
			fish.inCatchRadius = true
			fish.modulate = Color.RED
			
func register_fish_in_orbit(fish: Fish) -> void:
	if fish.center == null or fish.center == self:
		fish.center = self
		fish.state = Fish.State.ORBITING
		if fish not in fishInOrbit:
			fishInOrbit.append(fish)
			print(self.name, "Added fish to orbit list: ", fish.name)

			
func startFishing():
	state = State.FISHING
	orbitArea.monitoring = true
	catchArea.monitoring = true
	queue_redraw()
