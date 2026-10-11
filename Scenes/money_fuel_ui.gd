extends CanvasLayer

@export var moneyTextControl: Control
@export var fuelTextControl: Control
@export var moneyText: RichTextLabel
@export var fuelText: RichTextLabel

var shake_tween: Tween
var previous_fuel: float = 100.0

func _process(delta: float) -> void:
	if(ScoreAndUpgrades.in_market):
		visible = false
	else:
		visible = true

func UpdateMoneyText() -> void:
	moneyText.text = "$%.2f" % ScoreAndUpgrades.money
	ShakeBox(true)

func UpdateFuelText() -> void:
	fuelText.text = "Fuel: %.2f%%" % ScoreAndUpgrades.fuel_quantity

	var current_fuel = ScoreAndUpgrades.fuel_quantity

	if current_fuel < previous_fuel:
		if int(previous_fuel / 10) > int(current_fuel / 10):
			ShakeBox(false)

	previous_fuel = current_fuel

func ShakeBox(isMoney: bool) -> void:
	var targetControl: Control
	var targetText: RichTextLabel

	if isMoney:
		targetControl = moneyTextControl
		targetText = moneyText
	else:
		targetControl = fuelTextControl
		targetText = fuelText

	# Stop any previous shake
	if shake_tween and shake_tween.is_running():
		shake_tween.kill()

	# Remember the original position
	var original_x = targetControl.position.x

	# Shake the selected control
	shake_tween = create_tween()
	shake_tween.tween_property(targetControl, "position:x", original_x + 6.0, 0.05)
	shake_tween.tween_property(targetControl, "position:x", original_x - 6.0, 0.05)
	shake_tween.tween_property(targetControl, "position:x", original_x + 4.0, 0.05)
	shake_tween.tween_property(targetControl, "position:x", original_x, 0.05)
