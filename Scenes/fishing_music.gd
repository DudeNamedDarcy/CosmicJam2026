extends AudioStreamPlayer2D

@export var intro: AudioStream = preload("res://Scenes/Audio/Music/fishing_intro.mp3")
@export var loop: AudioStream = preload("res://Scenes/Audio/Music/fishing_loop.mp3")
@export var shop: AudioStream = preload("res://Scenes/Audio/Music/shop.mp3")

var inShop = false;

func _ready() -> void:
	finished.connect(_on_finished)
	play_intro()
	
func _process(float) -> void:
	if(ScoreAndUpgrades.in_market && not inShop):
		inShop = true
		stream = shop
		if not playing:
			play()
	elif(!ScoreAndUpgrades.in_market):
		if(inShop):
			inShop = false
			stream = loop
			if not playing:
				play()
	

func play_intro() -> void:
	stream = intro
	play()

func _on_finished() -> void:
	if stream == intro:
		stream = loop
		play()
	elif stream == loop:
		play()
