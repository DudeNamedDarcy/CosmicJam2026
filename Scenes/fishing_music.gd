extends AudioStreamPlayer2D

@export var intro: AudioStream = preload("res://Scenes/Audio/Music/fishing_intro.mp3")
@export var loop: AudioStream = preload("res://Scenes/Audio/Music/fishing_loop.mp3")

func _ready() -> void:
	finished.connect(_on_finished)
	play_intro()

func play_intro() -> void:
	stream = intro
	play()

func _on_finished() -> void:
	if stream == intro:
		stream = loop
		play()
	elif stream == loop:
		play()
