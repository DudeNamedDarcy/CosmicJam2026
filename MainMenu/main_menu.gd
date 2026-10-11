extends Control

@export var screenFade: ColorRect

# Called when the node enters the scene tree for the first time.
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

	await tween.finished

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_button_pressed() -> void:
	var fadeDuration = 1.0
	
	var tween = create_tween()
	tween.tween_property(
		screenFade,
		"color:a",
		1.0,
		fadeDuration
	)

	await tween.finished
	
	get_tree().change_scene_to_file("res://Scenes/game_scene.tscn")


func _on_credits_button_pressed() -> void:
	var fadeDuration = 1.0
	
	var tween = create_tween()
	tween.tween_property(screenFade, "color", Color(0,0,0,1), fadeDuration)
	await get_tree().create_timer(fadeDuration).timeout
	
	get_tree().change_scene_to_file("res://Scenes/Credits/normal_credits.tscn")


func _on_quit_button_pressed() -> void:
	var fadeDuration = 1.0
	
	var tween = create_tween()
	tween.tween_property(screenFade, "color", Color(0,0,0,1), fadeDuration)
	await get_tree().create_timer(fadeDuration).timeout
	
	get_tree().quit()
