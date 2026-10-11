extends AudioStreamPlayer2D

@export var acceleration: AudioStream = preload("res://Scenes/Audio/SFX/boat_accelerating.mp3")
@export var deceleration: AudioStream = preload("res://Scenes/Audio/SFX/boat_decelerating.mp3")
@export var motion: AudioStream = preload("res://Scenes/Audio/SFX/boat_motion.mp3")

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
		play()

func decelerating() -> void:
	if stream != deceleration:
		stream = deceleration
	if not playing:
		play()

func motioning() -> void:
	if stream != motion:
		stream = motion
	if not playing:
		play()
