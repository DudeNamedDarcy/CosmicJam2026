extends Node2D

@export var bobberScene: PackedScene = preload("res://Scenes/Bobbers/Pluto.tscn")


func _on_button_pressed() -> void:

	var bobber = bobberScene.instantiate()

	bobber.position = Vector2(0,0)

	add_child(bobber)
