extends Node3D
@export var forwardSpeed: float = 10
@export var sensitivity: float = .5
@export var moveLerp: float = 1;
@export var range: float = 50;
@export var tiltAmount: float = 2
@export var tiltLerp: float = 5

var targetPos: Vector3
var velocity: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		targetPos.x -= event.relative.x * sensitivity #x in inverted
		targetPos.y -= event.relative.y * sensitivity #y is inverted
		targetPos.x = clamp(targetPos.x, -range/2, range/2)
		targetPos.y = clamp(targetPos.y, -range/2, range/2)
	elif event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var prev_position = position
	
	position.x = lerp(position.x, targetPos.x, moveLerp * delta)
	position.y = lerp(position.y, targetPos.y, moveLerp * delta)
	position.z += forwardSpeed * delta
	
	velocity = position - prev_position
	
	rotation.z = lerp(rotation.z, -velocity.x * tiltAmount, tiltLerp * delta)
	rotation.x = lerp(rotation.x, velocity.y * tiltAmount, tiltLerp * delta)
