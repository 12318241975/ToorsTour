extends Node3D

@export var obstacle_scenes: Array[PackedScene] = []
@export var obstacle_count: int = 4
@export var spawn_area: Vector3 = Vector3(10, 0, 5)

func _ready():
	for i in obstacle_count:
		_spawn_obstacle()

func _spawn_obstacle():
	if obstacle_scenes.is_empty():
		return
	
	var scene = obstacle_scenes[randi() % obstacle_scenes.size()]
	var obstacle = scene.instantiate()
	
	obstacle.position = Vector3(
		randf_range(-spawn_area.x, spawn_area.x),
		randf_range(-spawn_area.y, spawn_area.y),
		randf_range(-spawn_area.z, spawn_area.z)
	)
	
	add_child(obstacle)
