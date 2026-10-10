extends Node2D
class_name Bobber

@export var bobberType: String
@export var bobberTexture: Texture2D
@export var startingOrbitRadius: float
@export var startingCatchRadius: float

@export var bobberSprite: Sprite2D
@export var orbitArea: Area2D
@export var catchArea: Area2D

var orbitRadius: float
var catchRadius: float
var caughtFish: Array[Fish]

func _ready() -> void:
	orbitRadius = startingOrbitRadius
	catchRadius = startingCatchRadius
	bobberSprite.texture = bobberTexture

func _draw() -> void:
	# Orbit Circle
	draw_circle(position, orbitRadius, Color.WHITE, false, 5.0)
	# Catch Circle
	draw_circle(position, catchRadius, Color.WHITE, false, 2.0)
	
# call this function to get fish in range, after calling this function, queue free bobber and fish from caller function
func reelIn() -> Array[Fish]:
	for fish in caughtFish:
		print("Fish Name: ", fish.typeName, ", Value: ", fish.value)
	return caughtFish


func _on_catch_area_entered(area: Area2D) -> void:
	if area.get_parent() is Fish:
		var fish = area.get_parent()
		if fish.getInCatchRadius() == false:
			caughtFish.append(fish)
			fish.setInCatchRadius(true)
