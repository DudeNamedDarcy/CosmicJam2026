extends Camera2D

@export var shakeFade: float = 5.0
@export var shakeStrength: float = 0.0

var rng = RandomNumberGenerator.new()
var comboCount: int = 0
func _ready() -> void:
	LevelManager.shake_camera.connect(ApplyShake)
	LevelManager.shake_camera_combo.connect(FishComboShake)
	LevelManager.shake_camera_combo_clear.connect(ResetFishComboShake)
	
func ApplyShake(str: float,  time: float = 0.2):
	shakeStrength = str

func FishComboShake():
	comboCount += 1
	ApplyShake(min(2.0*(comboCount), 5.0), .1)

func ResetFishComboShake():
	comboCount = 0
	
func _process(delta):
	if shakeStrength > 0:
		shakeStrength = lerpf(shakeStrength, 0, shakeFade * delta)
		offset = RandomOffset()

func RandomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shakeStrength, shakeStrength), rng.randf_range(-shakeStrength, shakeStrength))
