extends Node3D

@export var emptyScene: PackedScene
@export var segment_scenes: Array[PackedScene] = []
@export var segment_weights: Array[int] = []
@export var segments_ahead: int = 3
@export var fullSegments_ahead: int = 2
@export var segment_length: float = 20.0

var _spawn_z: float = 0.0
var _active_segments: Array = []
@onready var player = $"player/Playerbody"

func _ready():
	for i in segments_ahead:
		_spawn_segment(emptyScene)
	for i in fullSegments_ahead:
		_spawn_segment(_pick_weighted_scene())

func _process(_delta):
	if player == null:
		return
	
	while _spawn_z < player.position.z + ((segments_ahead + fullSegments_ahead) * segment_length):
		_spawn_segment(_pick_weighted_scene())
	
	_cleanup_old_segments()

func _pick_weighted_scene() -> PackedScene:
	var total_weight: int = 0
	for weight in segment_weights:
		total_weight += weight
	
	var roll := randi() % total_weight
	var cumulative: int = 0
	var index = 0
	for weight in segment_weights:
		cumulative += weight
		if roll < cumulative:
			return segment_scenes[index]
		index += 1;
	return null

func _spawn_segment(scene: PackedScene):
	var segment = scene.instantiate()
	segment.position.z = _spawn_z
	add_child(segment)
	_active_segments.append(segment)
	_spawn_z += segment_length

func _cleanup_old_segments():
	for segment in _active_segments:
		if segment.position.z < player.position.z - segment_length * 2:
			segment.queue_free()
			_active_segments.erase(segment)
