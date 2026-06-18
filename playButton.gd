extends MeshInstance3D

@export_group("Settings")
@export var tilt_amount: float = 5.0
@export var lerp_speed: float = .1
@export var translate_amount: float = 1
@export var targetMat: StandardMaterial3D
@export var emission_low: float = 0;
@export var emission_high: float = 10;

var targetRot = Vector3.ZERO
var startRot = Vector3.ZERO
var starty = 0
var targety = 0

func _ready() -> void:
	startRot = rotation
	targetRot = startRot
	starty = position.y
	targety = starty
	
func _on_button_mouse_entered() -> void:
	targetRot.x = randf_range(-tilt_amount, tilt_amount)
	targetRot.z = randf_range(-tilt_amount, tilt_amount)
	targety = starty + translate_amount
	targetMat.emission_energy_multiplier = emission_high


func _on_button_mouse_exited() -> void:
	targetRot = startRot
	targety = starty
	targetMat.emission_energy_multiplier = emission_low

func _process(delta: float) -> void:
	var tilt_x = lerp(rotation.x, targetRot.x, lerp_speed)
	var tilt_z = lerp(rotation.z, targetRot.z, lerp_speed)
	
	position.y = lerp(position.y, targety, lerp_speed)
	
	rotation.x = tilt_x
	rotation.z = tilt_z
