extends AudioStreamPlayer2D

@export var throw: AudioStream = preload("res://Scenes/Audio/SFX/v2/throw.mp3")
@export var win: AudioStream = preload("res://Scenes/Audio/SFX/v2/get_fish.mp3")
@export var lose: AudioStream = preload("res://Scenes/Audio/SFX/v2/lose_fish.mp3")
@export var combo: AudioStream = preload("res://Scenes/Audio/SFX/v2/combo.mp3")
@export var reel: AudioStream = preload("res://Scenes/Audio/SFX/v2/reeling.mp3")

var comboCount
var reelMax
var reelPossible = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	comboCount = 0
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(stream == reel):
		if(get_playback_position()>=reelMax):
			stop_reeling()
	pass

func throwing():
	comboCount = 0
	stream = throw
	if(not playing):
		play()

func winning():
	pitch_scale = 1
	stream = win
	if(not playing):
		play()
		
func losing():
	pitch_scale = randf_range(1,1.3)
	stream = lose
	if(not playing):
		play()
		
func comboing():
	comboCount+=1
	stream = combo
	pitch_scale = 1+float(1+comboCount)/10 if comboCount<7 else 1.8
	print(pitch_scale)
	play()
	
func reeling(reelTime):
	if reelPossible:
		pitch_scale = 1
		reelMax = reelTime
		stream = reel
		if(not playing):
			play()
	
func stop_reeling():
	if(stream == reel):
		stop()
	pass
	
func fuck_reeling():
	reelPossible = false;

func yes_reeling():
	reelPossible = true;
