extends Node3D

var phych2 = load("res://textures/phych.tres")

@export var bpm: float = 130.0
@export var rest_brightness: float = 0.5
@export var max_brightness: float = 8.0
@export var decay_steepness: float = 4.0 # Higher = faster snap, longer tail

var time_passed: float = 0.0
var fade_in: float = 0.0
@export var fade_speed: float = 0.5

func _process(delta: float) -> void:
	# 1. Initial fade-in of the effect
	fade_in = min(1.0, fade_in + fade_speed * delta)
	
	# 2. Progress through the beats
	time_passed += delta * (bpm / 60.0)
	
	# 3. Create a "Sawtooth" ramp (goes 0 to 1, then snaps back to 0)
	var beat_progress = fmod(time_passed, 1.0)
	
	# 4. Invert it: Starts at 1.0 (on the beat) and goes to 0.0
	var pulse = 1.0 - beat_progress
	
	# 5. The Magic: Raise it to a power to make it "curved"
	# This makes the drop-off start very sharp and slow down at the end
	pulse = pow(pulse, decay_steepness)
	
	# 6. Apply to material
	var final_strength = lerp(rest_brightness, max_brightness, pulse)
	phych2.emission_energy_multiplier = final_strength * fade_in
