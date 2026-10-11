extends Node2D

var ship_at_market:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("ScoreAndUpgrades.in_market is: " + str(ScoreAndUpgrades.in_market))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		if ship_at_market:
			ScoreAndUpgrades.in_market = true


func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.name == "starship":
		ship_at_market = true
		print("at market now true!")

func _on_area_2d_area_exited(area: Area2D) -> void:
	print(area.name)
	if area.name == "starship":
		ship_at_market = false
		print("at market now false!")
