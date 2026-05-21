extends Node3D

@export_group("Hover Settings")
@export var hover_height: float = 0.5
@export var hover_speed: float = 2.0

@export_group("Tilt Settings")
@export var tilt_amount: float = 5.0
@export var tilt_speed: float = 1.5

# Internal offsets to ensure each instance is unique
var time_offset: float = 0.0
var individual_speed_modifier: float = 1.0
@onready var start_y: float = position.y

func _ready() -> void:
	# 1. Randomize the starting position in the cycle (0 to 2*PI)
	time_offset = randf_range(0.0, 10.0)
	
	# 2. Slightly vary the speed so they don't stay in a rhythm together
	individual_speed_modifier = randf_range(0.8, 1.2)

func _process(delta: float) -> void:
	# Apply the offset and the unique speed modifier
	var local_time = (Time.get_ticks_msec() / 1000.0 + time_offset) * individual_speed_modifier
	
	# Vertical Movement
	var new_y = start_y + (sin(local_time * hover_speed) * hover_height)
	position.y = new_y
	
	# Random-ish Tilting (using different offsets for X and Z for 'wobble')
	var tilt_x = sin(local_time * tilt_speed) * deg_to_rad(tilt_amount)
	var tilt_z = cos(local_time * tilt_speed * 0.7) * deg_to_rad(tilt_amount)
	
	rotation.x = tilt_x
	rotation.z = tilt_z
