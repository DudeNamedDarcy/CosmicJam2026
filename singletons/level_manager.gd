extends Node

signal level_up
signal shake_camera(str: float, time: float)
signal shake_camera_combo
signal shake_camera_combo_clear
var level: int = 0

func next_level():
	level+=1
	level_up.emit()
	print("Level up! Level: ", level)

func shakeCamera(str: float,  time: float = 0.2):
	shake_camera.emit(str, time)

func shakeCameraCombo():
	shake_camera_combo.emit()

func shakeCameraComboClear():
	shake_camera_combo_clear.emit()
