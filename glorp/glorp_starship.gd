extends Node2D

var ship_at_market:bool = false
@export var market: CanvasLayer

@onready var area_2d: Area2D = $Area2D
@export var playerController: PlayerController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_2d.name = "market"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") && (playerController.playerState == playerController.PlayerState.Idle || playerController.playerState == playerController.PlayerState.Moving):
		if ship_at_market:
			LevelManager.pauseGame()
			ScoreAndUpgrades.in_market = true
			market.visible = true


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
