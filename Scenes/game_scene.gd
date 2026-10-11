extends Node2D

@export var screenFade: ColorRect

func _ready() -> void:
	var fadeDuration = 1.0
	var tween = create_tween()
	tween.tween_property(screenFade, "color", Color(0,0,0,0), fadeDuration)
