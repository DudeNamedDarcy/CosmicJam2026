extends Node

signal level_up
signal shake_camera(str: float)

var level: int = 0

func next_level():
	level+=1
	level_up.emit()
	print("Level up! Level: ", level)

func shakeCamera(str: float):
	shake_camera.emit(str)

