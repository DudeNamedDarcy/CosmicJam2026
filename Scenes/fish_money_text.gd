extends Control

@onready var label: RichTextLabel = $RichTextLabel

var shake_tween: Tween

func DisplayTotalEarnings(money: float) -> void:
	label.text = "TOTAL: $%.2f" % money
		# Stop any previous shake
	if shake_tween and shake_tween.is_running():
		shake_tween.kill()
		# Shake the control
	shake_tween = create_tween()
	shake_tween.tween_property(self, "position:x", position.x + 6.0, 0.05)
	shake_tween.tween_property(self, "position:x", position.x - 6.0, 0.05)
	shake_tween.tween_property(self, "position:x", position.x + 4.0, 0.05)
	shake_tween.tween_property(self, "position:x", position.x, 0.05)

	# Remove the text after one second
	await get_tree().create_timer(2.0).timeout
	label.text = ""
	queue_free()

func DisplayText(money: float) -> void:
	label.text = "+$%.2f" % money

	# Stop any previous shake
	if shake_tween and shake_tween.is_running():
		shake_tween.kill()

	# Shake the control
	shake_tween = create_tween()
	shake_tween.tween_property(self, "position:x", position.x + 6.0, 0.05)
	shake_tween.tween_property(self, "position:x", position.x - 6.0, 0.05)
	shake_tween.tween_property(self, "position:x", position.x + 4.0, 0.05)
	shake_tween.tween_property(self, "position:x", position.x, 0.05)

	# Remove the text after one second
	await get_tree().create_timer(1.0).timeout
	label.text = ""
	queue_free()

	
