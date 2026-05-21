extends Node3D

@export var targetMat: StandardMaterial3D

@export var bpm: float = 130.0
@export var rest_brightness: float = 0.0 # Set to 0 for pure black between beats
@export var max_brightness: float = 8.0
@export var decay_steepness: float = 4.0 

@export_range(0.0, 1.0) var max_tint_amount: float = 1.0 
@export var fade_speed: float = 0.5

var time_passed: float = 0.0
var fade_in: float = 0.0
var last_beat_index: int = -1 
var current_color: Color = Color.BLACK # Start at black

func _process(delta: float) -> void:
	# 1. Global Fade-in (Initial game start)
	fade_in = min(1.0, fade_in + fade_speed * delta)
	
	# 2. Beat Tracking
	time_passed += delta * (bpm / 60.0)
	var current_beat_index = int(time_passed)
	
	# Detect new beat and pick a new target color
	if current_beat_index > last_beat_index:
		pick_new_color()
		last_beat_index = current_beat_index

	# 3. Pulse Math (1.0 at hit, 0.0 at rest)
	var beat_progress = fmod(time_passed, 1.0)
	var pulse = pow(1.0 - beat_progress, decay_steepness)
	
	# 4. Color Logic: Fade from Black to the Random Color
	# This ensures the "hue" disappears as the light dims
	var tinted_color = Color.BLACK.lerp(current_color, max_tint_amount)
	
	# 5. Apply to Material
	var final_strength = lerp(rest_brightness, max_brightness, pulse)
	
	# We multiply the color by the pulse here to ensure it goes to black
	targetMat.emission = tinted_color * pulse
	targetMat.emission_energy_multiplier = final_strength * fade_in

func pick_new_color():
	current_color = Color.from_hsv(randf(), 1.0, 1.0)
