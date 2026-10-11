extends CharacterBody2D
class_name Bobber

enum State { UNCASTED, CASTING, FISHING }

@export var bobberType: String
@export var bobberTexture: Texture2D
@export var startingOrbitRadius: float
@export var startingCatchRadius: float

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

func getBobberName() -> String:
	return bobberType
	
func _ready() -> void:
	orbitRadius = startingOrbitRadius
	catchRadius = startingCatchRadius
	bobberSprite.texture = bobberTexture
	orbitArea.monitoring = false
	catchArea.monitoring = false
	state = State.UNCASTED
	
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
		draw_circle(Vector2.ZERO, orbitRadius, Color.WHITE, false, 3.0)
		# Catch Circle
		draw_circle(Vector2.ZERO, catchRadius, Color.WHITE, false, 1.0)
	
# call this function to get fish in range, after calling this function, queue free bobber and fish from caller function
func reelIn() -> Array[Fish]:
	for fish in caughtFish:
		print("Fish Name: ", fish.typeName, ", Value: ", fish.value)
	return caughtFish
	
func cast(direction: Vector2, power: float, deceleration: float, line: Line2D):
	castDirection = direction
	castPower = power
	castLine = line
	castDeceleration = deceleration
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
