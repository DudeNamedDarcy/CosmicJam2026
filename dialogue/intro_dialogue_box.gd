extends Control

#Special Thanks To GDQuest's Learn 2D Gamedev From Zero With Godot 4, Lesson 6 for all the help with this!

@onready var rich_text_label: RichTextLabel = %RichTextLabel
#@onready var button: Button = $Button
@onready var audio_stream_player: AudioStreamPlayer = %AudioStreamPlayer

var dialogue: Array[String] = ["Test1",
"Test2Test2",
"Test3Test3Test3",
]

var pluto_dialogue: Array[String] = ["Ok. All I'm giving you is this tiny dwarf planet to start with.",
"Pluto was its name or something like that.",
"Catch some fish and I'll give you a bigger bobber :3."]

var mercury_dialogue: Array[String] = ["Huh. You're doing better than I thought.",
"Ok, here's a larger bobber for you. Name's Mercury.",
"There's even larger ones from where that iron ball came from if you keep this up!"]

var mars_dialogue: Array[String] = ["COD DAMN!! For a pathetic little starfisher, you’ve got guts! Those Red Dwarf Herring are a real pita bread.
", "You’re far from done, son. Now, I want a big tasty Angler Fish. 
Oh, and you’ll need this."]

var venus_dialogue: Array[String] = ["Whoa! That was quick! My kitty stomach barely started growling.
", "Bring me r.dia. You’re gonna need this here Venus."]

var earth_dialogue: Array[String] = ["YAAYYYY!! r.dia !! My fifth favourite…:
", "Close behind Gas Giant Squid!"]

var neptune_dialogue: Array[String] = ["You’re not getting tired of this, are you? STILL DON’T CARE!!
", "Cold temp surface for a nice cold Patrick Starfish (licks upper lip with both tongues)."]

var uranus_dialogue: Array[String] = ["DINNER TIIIIME!! Hehehe.
", "Alright, big leagues now, m’boy. Gold Fish."]

var saturn_dialogue: Array[String] = ["That caviar gave me dire dire diarrhea!!
", "I need another Gold Fish to rehydrate."]

var jupiter_dialogue: Array[String] = ["You’ve got sole, squiddo. Few are brave enough to starfish like you do.
", "Thanks for your help!!!"]

var active_tween:Tween

var current_dialogue_index = 0

var current_array:Array[String]

var text_done: bool = false
var doing_one_shot: bool = false

var current_quest = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame #yeah checks out
	await get_tree().process_frame
	show_text(pluto_dialogue)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func calling_dialogues():
	current_dialogue_index = 0
	#calling_dialogues called in Intro Dialogue called!
	current_quest += 1
	match current_quest:
		0:
			show_text(pluto_dialogue)
		1:
			show_text(mercury_dialogue)
		2:
			show_text(mars_dialogue)
		3:
			show_text(venus_dialogue)
		4:
			show_text(earth_dialogue)
		5:
			show_text(neptune_dialogue)
		6:
			show_text(uranus_dialogue)
		7:
			show_text(saturn_dialogue)
		8:
			show_text(jupiter_dialogue)



func show_text(array: Array[String]) -> void:
	LevelManager.pauseGame()
	current_array = array
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
	await get_tree().create_timer(tween_duration + 1.2).timeout 
	_advance()


func _text_is_done() -> void:
	text_done = true


func _advance() -> void:
	current_dialogue_index += 1
	if current_dialogue_index == current_array.size():
		LevelManager.unpauseGame()
		hide()
	else:
		show_text(current_array)
