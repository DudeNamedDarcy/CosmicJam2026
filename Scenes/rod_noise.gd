extends AudioStreamPlayer2D

@export var throw: AudioStream = preload("res://Scenes/Audio/SFX/v2/throw.mp3")
@export var win: AudioStream = preload("res://Scenes/Audio/SFX/v2/get_fish.mp3")
@export var lose: AudioStream = preload("res://Scenes/Audio/SFX/v2/lose_fish.mp3")
@export var combo: AudioStream = preload("res://Scenes/Audio/SFX/v2/combo.mp3")
@export var reel: AudioStream = preload("res://Scenes/Audio/SFX/v2/reeling.mp3")
@export var start: AudioStream = preload("res://Scenes/Audio/SFX/v2/start.mp3")
@export var success: AudioStream = preload("res://Scenes/Audio/SFX/v2/success_combo.mp3")
@export var win_plateau: AudioStream = preload("res://Scenes/Audio/SFX/v2/win_plateau.mp3")
@export var combo_plateau: AudioStream = preload("res://Scenes/Audio/SFX/v2/combo_plateau.mp3")

var comboCount
var winCount = 0
var reelMax = 0
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
	winCount = 0
	comboCount = 0
	stream = throw
	if(not playing):
		play()

func winning():
	if winCount<6:
		pitch_scale = 1+float(1+winCount)/10
		winCount+=1
		stream = win
	else:
		pitch_scale = 1
		stream = win_plateau
		# stream = winPlateau
	if(not playing):
		play()
		
func losing():
	pitch_scale = randf_range(1,1.3)
	stream = lose
	if(not playing):
		play()
		
func comboing():
	comboCount+=1
	if comboCount<9:
		stream = combo
		pitch_scale = 1+float(1+comboCount)/10 
	else:
		pitch_scale = 1
		stream = combo_plateau
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
	
func start_fishing():
	pitch_scale = randf_range(1,1.3)
	stream = start
	if(not playing):
		play()
		
func combo_win():
	pitch_scale = randf_range(1,1.05)
	stream = success
	if(not playing):
		play()
