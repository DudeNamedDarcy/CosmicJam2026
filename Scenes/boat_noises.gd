extends AudioStreamPlayer2D

@export var acceleration: AudioStream = preload("res://Scenes/Audio/SFX/v2/boat_accelerating.mp3")
@export var deceleration: AudioStream = preload("res://Scenes/Audio/SFX/v2/boat_decelerating.mp3")
@export var motion: AudioStream = preload("res://Scenes/Audio/SFX/v2/boat_motion.mp3")

var sema = false

func _process(_delta: float) -> void:
	if stream == acceleration:
		var accel_length := 0.0
		if get_stream() != null:
			accel_length = get_stream().get_length()
		if accel_length > 0.0 and get_playback_position() >= accel_length - 0.05:
			motioning()

func accelerating() -> void:
	if stream != acceleration:
		stream = acceleration
	if not playing:
		sema = true
		play()

func decelerating() -> void:
	if sema:
		if stream != deceleration:
			stream = deceleration
		if not playing:
			stream.loop = false
			print(stream)
			print(stream.loop)
			play()
		sema = false

func motioning() -> void:
	if stream != motion:
		stream = motion
		stream.loop = true
	if not playing:
		play()
