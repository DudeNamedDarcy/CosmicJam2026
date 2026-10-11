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
@onready var broke_alert_label: RichTextLabel = %BrokeAlertLabel
@onready var fuel_label: Label = %FuelLabel
@onready var fuel_button: Button = $VBoxContainer/FuelButton
@onready var quit_button: Button = %QuitButton



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

var purchase_dialogue: Array[String] = ["Eh, that upgrade's okay, I guess!",
"Good boy",
"Holy mackerel! Took you long enough!",
"A worthless purchase",
"Just big and greedy, you are",
"Bogos binted?"
]

var leave_dialogue: Array[String] = ["zeep zorp",
"Best of luck on those catches!",
"Never come back. Wait, you owe me money. Okay come back later. But not now, I’m tired of you.",
"It’s never too late to repent."
]

var broke_dialogue: Array[String] = ["Imagine being broke LOL",
"Come back when you're a little... richer!"]

var out_of_money_bool: bool = true
var quit_pressed: bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	if visible:
		initialize_market()

func initialize_market() -> void:
	broke_alert_label.hide()
	dialogue_box.dialogue = intro_dialogue
	dialogue_box.current_dialogue_index = randi_range(0, len(intro_dialogue) -1)
	dialogue_box.show_text(dialogue_box.dialogue)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	money_label.text = "Money: $" + str(ScoreAndUpgrades.money)
	fuel_label.text = "Fuel: %.2f" % (ScoreAndUpgrades.fuel_quantity) + "%"
	#print(ScoreAndUpgrades.money)

func _out_of_money() -> void:
	out_of_money_bool = false
	no_money_stream_player.play()

	dialogue_box.dialogue = broke_dialogue
	dialogue_box.current_dialogue_index = randi_range(0, len(broke_dialogue) -1)
	dialogue_box.show_text(dialogue_box.dialogue)

	broke_alert_label.show()
	await get_tree().create_timer(1.5).timeout
	#shoutout this video for making me remember await and making timers in code: https://www.youtube.com/watch?v=1sYgGvrDYag&t=851s
	broke_alert_label.hide()
	out_of_money_bool = true

func _on_orbit_radius_button_pressed() -> void:
	if ScoreAndUpgrades.orbit_radius_progress < 2 and (ScoreAndUpgrades.money) > 0:
		ScoreAndUpgrades.orbit_radius_progress += 1
	#print(ScoreAndUpgrades.orbit_radius_progress)
	_handle_money(orbit_radius_progress, 200, orbit_radius_button)

func _on_catch_radius_button_pressed() -> void:
	if ScoreAndUpgrades.catch_radius_progress < 2 and (ScoreAndUpgrades.money) > 0:
		ScoreAndUpgrades.catch_radius_progress += 1
	#print(ScoreAndUpgrades.catch_radius_progress)
	_handle_money(catch_radius_progress, 200, catch_radius_button)

func _on_faster_ship_button_pressed() -> void:
	if ScoreAndUpgrades.faster_ship_progress < 2 and (ScoreAndUpgrades.money) > 0:
		ScoreAndUpgrades.faster_ship_progress += 1
	#print(ScoreAndUpgrades.faster_ship_progress)
	_handle_money(faster_ship_progress, 200, faster_ship_button)

func _on_larger_combos_button_pressed() -> void:
	if ScoreAndUpgrades.larger_combo_progress < 2 and (ScoreAndUpgrades.money) > 0:
		ScoreAndUpgrades.larger_combo_progress += 1
	#print(ScoreAndUpgrades.larger_combo_progress)
	_handle_money(larger_combos_progress, 200, larger_combos_button)

func _on_longer_combo_button_pressed() -> void:
	if ScoreAndUpgrades.longer_combo_progress < 2 and (ScoreAndUpgrades.money) > 0:
		ScoreAndUpgrades.longer_combo_progress += 1
	#print(ScoreAndUpgrades.longer_combo_progress)
	_handle_money(longer_combo_progress, 200, longer_combo_button)


func _on_larger_fuel_button_pressed() -> void:
	if ScoreAndUpgrades.larger_fuel_progress < 2 and (ScoreAndUpgrades.money) > 0:
		ScoreAndUpgrades.larger_fuel_progress += 1
	#print(ScoreAndUpgrades.larger_fuel_progress)
	_handle_money(larger_fuel_progress, 200, larger_fuel_button)



func _handle_money(given_progress_bar: ProgressBar, moneyAmount:int, given_button: Button):
	if (ScoreAndUpgrades.money) >= moneyAmount and given_progress_bar.value < 100:
		activate_buy_dialogue()
		print("enough money!")
		(ScoreAndUpgrades.money) -= moneyAmount
		given_progress_bar.value += 50
		cha_ching_audio_stream_player.play()
		if given_progress_bar.value >= 100:
			given_button.text = "Sold Out!"
	elif (ScoreAndUpgrades.money) < moneyAmount:
		if out_of_money_bool:
			_out_of_money()
	else:
		return

func activate_buy_dialogue() -> void:
	dialogue_box.dialogue = purchase_dialogue
	dialogue_box.current_dialogue_index = randi_range(0, len(purchase_dialogue) -1)
	dialogue_box.show_text(dialogue_box.dialogue)


func _on_fuel_button_pressed() -> void:
	_add_fuel()

func _add_fuel() -> void:
	if ScoreAndUpgrades.fuel_quantity >= 100 and (ScoreAndUpgrades.money) >= 200:
		return
	elif ScoreAndUpgrades.fuel_quantity < 100 and (ScoreAndUpgrades.money) < 200:
		if out_of_money_bool:
			_out_of_money()
	elif ScoreAndUpgrades.fuel_quantity >= 100 and (ScoreAndUpgrades.money) < 200:
		if out_of_money_bool:
			_out_of_money()
	else:
		ScoreAndUpgrades.fuel_quantity += 20
		(ScoreAndUpgrades.money) -= 200
		cha_ching_audio_stream_player.play()


func _on_quit_button_pressed() -> void:
	if quit_pressed == false:
		_leave_market()
	else:
		pass

func _leave_market() -> void:
	quit_pressed = true
	dialogue_box.dialogue = leave_dialogue
	dialogue_box.current_dialogue_index = randi_range(0, len(leave_dialogue) -1)
	dialogue_box.show_text(dialogue_box.dialogue)
	await get_tree().create_timer((len(leave_dialogue[dialogue_box.current_dialogue_index]) / 16.0) + 1.5).timeout
	quit_pressed = false
	ScoreAndUpgrades.in_market = false
	visible = false
	LevelManager.unpauseGame()
