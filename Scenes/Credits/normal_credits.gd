extends Node2D

@export var screenFade: ColorRect

func _ready() -> void:
	screenFade.color.a = 1.0
	var fadeDuration = 1.0
	
	var tween = create_tween()
	tween.tween_property(
		screenFade,
		"color:a",
		0.0,
		fadeDuration
	)

func _on_button_pressed() -> void:
	var fadeDuration = 1.0
	
	var tween = create_tween()
	tween.tween_property(screenFade, "color", Color(0,0,0,1), fadeDuration)
	await get_tree().create_timer(fadeDuration).timeout
	
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
