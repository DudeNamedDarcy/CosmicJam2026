extends AudioStreamPlayer2D

@export var throw: AudioStream = preload("res://Scenes/Audio/SFX/throw.mp3")
@export var win: AudioStream = preload("res://Scenes/Audio/SFX/get_fish.mp3")
@export var lose: AudioStream = preload("res://Scenes/Audio/SFX/lose_fish.mp3")
@export var combo: AudioStream = preload("res://Scenes/Audio/SFX/combo.mp3")

var comboCount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	comboCount = 0
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func throwing():
	comboCount = 0
	stream = throw
	if(not playing):
		play()

func winning():
	stream = win
	if(not playing):
		play()
		
func losing():
	stream = lose
	if(not playing):
		play()
	
func comboing():
	comboCount+=1
	stream = combo
 	#set_pitch_scale(2.0)
	play()
