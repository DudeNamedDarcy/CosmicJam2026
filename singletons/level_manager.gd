extends Node

signal level_up
signal shake_camera

var level: int = 0

func next_level():
	level+=1
	level_up.emit()
	print("Level up! Level: ", level)
	
func cameraShake():
	shake_camera.emit()
