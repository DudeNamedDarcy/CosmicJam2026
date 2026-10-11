extends Camera2D

@export var shakeFade: float = 5.0
@export var shakeStrength: float = 0.0

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	LevelManager.shake_camera.connect(ApplyShake)
	
func ApplyShake(str: float):
	shakeStrength = str
	
func _process(delta):
	if shakeStrength > 0:
		shakeStrength = lerpf(shakeStrength, 0, shakeFade * delta)
		offset = RandomOffset()

func RandomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shakeStrength, shakeStrength), rng.randf_range(-shakeStrength, shakeStrength))
