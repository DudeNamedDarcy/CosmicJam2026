extends Control
class_name FishComboSprite
@export var sprite: Sprite2D
var fishData:Fish


func PopulateData(f: Fish) -> void:
	fishData = f
	sprite.texture = f.fishTexture
