extends Node

signal level_up
signal shake_camera(str: float, time: float)
signal shake_camera_combo
signal shake_camera_combo_clear
var level: int = 0
var isPaused = false

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
	
func pauseGame():
	if not isPaused:
		isPaused = true
		get_tree().paused = true
	
func unpauseGame():
	if isPaused:
		isPaused = false
		get_tree().paused = false
