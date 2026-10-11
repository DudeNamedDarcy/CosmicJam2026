extends CanvasLayer

@onready var orbit_radius_button: Button = $VBoxContainer/OrbitRadiusButton
@onready var orbit_radius_progress: ProgressBar = $VBoxContainer/OrbitRadiusProgress
@onready var catch_radius_button: Button = $VBoxContainer/CatchRadiusButton
@onready var catch_radius_progress: ProgressBar = $VBoxContainer/CatchRadiusProgress
@onready var faster_ship_button: Button = $VBoxContainer/FasterShipButton
@onready var faster_ship_progress: ProgressBar = $VBoxContainer/FasterShipProgress
@onready var larger_combos_button: Button = $VBoxContainer/LargerCombosButton
@onready var larger_combos_progress: ProgressBar = $VBoxContainer/LargerCombosProgress
@onready var longer_combo_button: Button = $VBoxContainer/LongerComboButton
@onready var longer_combo_progress: ProgressBar = $VBoxContainer/LongerComboProgress
@onready var larger_fuel_button: Button = $VBoxContainer/LargerFuelButton
@onready var larger_fuel_progress: ProgressBar = $VBoxContainer/LargerFuelProgress

@onready var money_label: Label = %MoneyLabel
@onready var warning_label: Label = %WarningLabel

@onready var cha_ching_audio_stream_player: AudioStreamPlayer = $ChaChingAudioStreamPlayer
@onready var no_money_stream_player: AudioStreamPlayer = $NoMoneyStreamPlayer
@onready var dialogue_box: Control = $DialogueBox


#Shoutout to Gwizz for the tutorial on subViewportContainers:
#https://www.youtube.com/watch?v=K_mZeYLYpgg

#And Mostly Mad Productions + Google AI for transparency on 3D scenes and SubViewports:
#https://www.youtube.com/watch?v=6JgycHywKXA

var intro_dialogue: Array[String] = ["You again. Ugh. If you want to quell my foul mood, buy my Wares.",
"I am Glorp of the Celestial Mob, and you will buy my Wares.",
"Now I have become Glorp, the seller of Wares.",
"Welcome to the BlackHole market. Prepare to Purchase my Wares.",
"You are truly an insatiable fellow."
]

var purchase_dialogue: Array[String] = ["Finally!",
"Good boy",
"Holy mackerel! Took you long enough!",
"A worthless purchase",
"Just big and greedy, you are"
]

var broke_dialogue: Array[String] = ["Imagine being broke LOL",
"Come back when you're a little... richer!"]

var totalMoney = (ScoreAndUpgrades.money)

var out_of_money_bool = true



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	warning_label.text = ""
	var chosen_index: int = randi_range(0, len(intro_dialogue) -1)
	dialogue_box.dialogue = intro_dialogue.slice(chosen_index, (chosen_index+1))
	dialogue_box.show_text(dialogue_box.dialogue)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	money_label.text = "Money: $" + str(totalMoney)

func _out_of_money() -> void:
	out_of_money_bool = false
	no_money_stream_player.play()
	warning_label.text = "Hey! You don't have enough money to buy that!"
	await get_tree().create_timer(3).timeout
	#shoutout this video for making me remember await and making timers in code: https://www.youtube.com/watch?v=1sYgGvrDYag&t=851s
	warning_label.text = ""
	out_of_money_bool = true

func _on_orbit_radius_button_pressed() -> void:
	_handle_money(orbit_radius_progress, 200, orbit_radius_button)

func _on_catch_radius_button_pressed() -> void:
	_handle_money(catch_radius_progress, 200, catch_radius_button)

func _on_faster_ship_button_pressed() -> void:
	_handle_money(faster_ship_progress, 200, faster_ship_button)

func _on_larger_combos_button_pressed() -> void:
	_handle_money(larger_combos_progress, 200, larger_combos_button)

func _on_longer_combo_button_pressed() -> void:
	_handle_money(longer_combo_progress, 200, longer_combo_button)

func _on_larger_fuel_button_pressed() -> void:
	_handle_money(larger_fuel_progress, 200, larger_fuel_button)

func _handle_money(given_progress_bar: ProgressBar, moneyAmount:int, given_button: Button):
	if totalMoney >= moneyAmount and given_progress_bar.value < 100:
		activate_buy_dialogue()
		print("enough money!")
		totalMoney -= moneyAmount
		given_progress_bar.value += 50
		cha_ching_audio_stream_player.play()
		if given_progress_bar.value >= 100:
			given_button.text = "Sold Out!"
	elif totalMoney < moneyAmount:
		if out_of_money_bool:
			_out_of_money()
	else:
		return

func activate_buy_dialogue() -> void:
	var chosen_index: int = randi_range(0, len(purchase_dialogue) -1)
	dialogue_box.dialogue = purchase_dialogue.slice(chosen_index, (chosen_index+1))
	dialogue_box.show_text(dialogue_box.dialogue)
