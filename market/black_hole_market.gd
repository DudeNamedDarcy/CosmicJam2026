extends CanvasLayer

@onready var orbit_radius_button: Button = $VBoxContainer/OrbitRadiusButton
@onready var orbit_radius_progress: ProgressBar = $VBoxContainer/OrbitRadiusProgress
@onready var catch_radius_button: Button = $VBoxContainer/CatchRadiusButton
@onready var catch_radius_progress: ProgressBar = $VBoxContainer/CatchRadiusProgress
@onready var faster_ship_button: Button = $VBoxContainer/FasterShipButton
@onready var faster_ship_progress: ProgressBar = $VBoxContainer/FasterShipProgress
@onready var larger_combos_progress: ProgressBar = $VBoxContainer/LargerCombosProgress
@onready var longer_combo_button: Button = $VBoxContainer/LongerComboButton
@onready var longer_combo_progress: ProgressBar = $VBoxContainer/LongerComboProgress
@onready var larger_fuel_button: Button = $VBoxContainer/LargerFuelButton
@onready var larger_fuel_progress: ProgressBar = $VBoxContainer/LargerFuelProgress

@onready var money_label: Label = %MoneyLabel
@onready var warning_label: Label = %WarningLabel

@onready var cha_ching_audio_stream_player: AudioStreamPlayer = $ChaChingAudioStreamPlayer


var totalMoney = (ScoreAndUpgrades.money)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	warning_label.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	money_label.text = "Money: $" + str(totalMoney)

func _out_of_money() -> void:
	warning_label.text = "Hey! You don't have enough money to buy that!"
	await get_tree().create_timer(4).timeout
	#shoutout this video for making me remember await and making timers in code: https://www.youtube.com/watch?v=1sYgGvrDYag&t=851s
	warning_label.text = ""

func _on_orbit_radius_button_pressed() -> void:
	_handle_money(orbit_radius_progress, 200)

func _on_catch_radius_button_pressed() -> void:
	_handle_money(catch_radius_progress, 200)

func _on_faster_ship_button_pressed() -> void:
	_handle_money(faster_ship_progress, 200)

func _on_larger_combos_button_pressed() -> void:
	_handle_money(larger_combos_progress, 200)

func _on_longer_combo_button_pressed() -> void:
	_handle_money(longer_combo_progress, 200)

func _on_larger_fuel_button_pressed() -> void:
	_handle_money(larger_fuel_progress, 200)

func _handle_money(given_progress_bar: ProgressBar, moneyAmount:int):
	if totalMoney > moneyAmount and given_progress_bar.value < 100:
		print("enough money!")
		totalMoney -= moneyAmount
		given_progress_bar.value += 25
		cha_ching_audio_stream_player.play()
	elif totalMoney < moneyAmount:
		_out_of_money()
	else:
		print("progress bar maxed!")
