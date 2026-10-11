extends Node

signal level_up

var level: int = 0

func next_level():
	level+=1
	level_up.emit()
	print("Level up! Level: ", level)
