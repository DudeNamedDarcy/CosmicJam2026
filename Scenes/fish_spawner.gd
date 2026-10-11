extends Node2D

@export var fishDict: Dictionary[PackedScene, int] = {}
@export var spawnableArea: Polygon2D

var currentSpawnableFish: Array[PackedScene] = []
var active = true
var coolingDown = false
var level = 0

func _ready() -> void:
	active = false
	LevelManager.level_up.connect(newLevel)
	LevelManager.next_level()

func _process(delta: float) -> void:
	if active && not coolingDown:
		spawnFish()
		coolingDown = true
		$"Spawn Timer".start()
	

func newLevel():
	level+=1
	for fish in fishDict:
		if fishDict[fish] == level:
			currentSpawnableFish.append(fish)
			
	active = true
			
func spawnFish():
	#full random
	var fishIndex = randi_range(0,currentSpawnableFish.size()-1)
	var fishToSpawn = currentSpawnableFish[fishIndex]
	var spawnPoint = generateSpawnLocation()
	var fish = fishToSpawn.instantiate()
	fish.global_position = spawnPoint
	add_child(fish)
	
func generateSpawnLocation() -> Vector2:
	var polygon_points = spawnableArea.polygon
	
	# Outer Bounds of box
	var min_x = polygon_points[0].x
	var max_x = polygon_points[0].x
	var min_y = polygon_points[0].y
	var max_y = polygon_points[0].y
	
	for point in polygon_points:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)
		
	# Keep picking random points until one lands inside the polygon
	var valid_point := Vector2.ZERO
	var found_valid_point := false
	
	while not found_valid_point:
		var test_point = Vector2(
			randf_range(min_x, max_x),
			randf_range(min_y, max_y)
		)
		
		if Geometry2D.is_point_in_polygon(test_point, polygon_points):
			valid_point = spawnableArea.to_global(test_point)
			found_valid_point = true
			
			return valid_point
			
	return Vector2(0,0)
	


func _on_spawn_timer_timeout() -> void:
	coolingDown = false
