extends Control

#Special Thanks To GDQuest's Learn 2D Gamedev From Zero With Godot 4, Lesson 6 for all the help with this!

@onready var rich_text_label: RichTextLabel = %RichTextLabel
#@onready var button: Button = $Button
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

var dialogue: Array[String] = ["Hello!",
"My name is Simon!",
"It is a pleasure to meet you!",
]

var current_dialogue_index = 0

var text_done: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_show_text()
	#button.pressed.connect(_advance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("dialogue_next") and current_dialogue_index < dialogue.size():
		if text_done:
			print("next!")
			_advance()



func _show_text() -> void:
	text_done = false
	rich_text_label.visible_ratio = 0
	var current_text = dialogue[current_dialogue_index]
	rich_text_label.text = current_text
	var tween_duration: float = current_text.length() / 10
	var sound_offset = audio_stream_player.stream.get_length() - tween_duration #so sound doesn't cut off
	var sound_start_position = randf() * sound_offset 
	audio_stream_player.play(sound_start_position)
	var tween = create_tween()
	tween.tween_property(rich_text_label, "visible_ratio", 1, tween_duration)
	tween.finished.connect(audio_stream_player.stop)
	tween.finished.connect(_text_is_done)

func _text_is_done() -> void:
	text_done = true

func _advance() -> void:
	current_dialogue_index += 1
	if current_dialogue_index == dialogue.size():
		return
	else:
		_show_text()
