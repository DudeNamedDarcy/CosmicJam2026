extends Node2D

@export var screenFade: ColorRect

func _ready() -> void:
	var fadeDuration = 1.0
	var tween = create_tween()
	tween.tween_property(screenFade, "color", Color(0,0,0,0), fadeDuration)

func _process(delta: float) -> void:
	if ScoreAndUpgrades.fuel_quantity<0:
		get_tree().change_scene_to_file("res://Scenes/Credits/loser_credits.tscn")
