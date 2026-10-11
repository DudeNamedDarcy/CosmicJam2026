extends Control

#Special Thanks To GDQuest's Learn 2D Gamedev From Zero With Godot 4, Lesson 6 for all the help with this!

@onready var rich_text_label: RichTextLabel = %RichTextLabel
#@onready var button: Button = $Button
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

var dialogue: Array[String] = ["Test1",
"Test2Test2",
"Test3Test3Test3",
]

var intro_dialogue: Array[String] = ["You again. Ugh. If you want to quell my foul mood, buy my Wares.",
"I am Glorp of the Celestial Mob, and you will buy my Wares.",
"Now I have become Glorp, the seller of Wares.",
"Welcome to the BlackHole market. Prepare to Purchase my Wares.",
"You are truly an insatiable fellow."
]

var purchase_dialogue: Array[String] = ["Eh, that upgrade's okay, I guess!",
"Good boy",
"Holy mackerel! Took you long enough!",
"A worthless purchase",
"Just big and greedy, you are"
]

var broke_dialogue: Array[String] = ["Imagine being broke LOL",
"Come back when you're a little... richer!"]

var active_tween:Tween

var current_dialogue_index = 0

var text_done: bool = false
var doing_one_shot: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame #yeah checks out
	await get_tree().process_frame
	#show_text(dialogue)
	#button.pressed.connect(_advance)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("dialogue_next") and current_dialogue_index < dialogue.size() and doing_one_shot == false:
		if text_done:
			print("next!")
			_advance(dialogue)


func show_text(array: Array[String]) -> void:
	text_done = false
	
	audio_stream_player.stop()
	if active_tween and active_tween.is_valid():
		active_tween.kill()
	
	rich_text_label.visible_ratio = 0
	
	var current_text = array[current_dialogue_index]
	rich_text_label.text = current_text
	var tween_duration: float = current_text.length() / 16.0
	
	var sound_offset = max(0.0, audio_stream_player.stream.get_length() - tween_duration) #so sound doesn't cut off
	var sound_start_position = randf() * sound_offset 
	audio_stream_player.play(sound_start_position)

	active_tween = create_tween()
	active_tween.tween_property(rich_text_label, "visible_ratio", 1, tween_duration)
	active_tween.finished.connect(audio_stream_player.stop)
	active_tween.finished.connect(_text_is_done)


func _text_is_done() -> void:
	text_done = true


func _advance(array: Array[String]) -> void:
	current_dialogue_index += 1
	if current_dialogue_index == dialogue.size():
		return
	else:
		show_text(array)
