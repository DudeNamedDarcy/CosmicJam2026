extends Control
class_name FishComboSprite
@export var sprite: Sprite2D
var fishData:Fish
var value: float

func PopulateData(f: Fish) -> void:
	fishData = f
	value = f.value
	sprite.texture = f.fishTexture

func KillFish(success: bool = true) -> void:
	if !success:
		queue_free()
		return
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2(0.1, 0.1), 0.3)
	LevelManager.shakeCameraCombo()
	tween.tween_callback(queue_free)
	
