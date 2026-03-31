extends Node3D
@export var forwardSpeed: float = 10
@export var speedIncrease: float = 1;
@export var sensitivity: float = .5
@export var moveLerp: float = 1;
@export var _range: float = 50;
@export var tiltAmount: float = 2
@export var tiltLerp: float = 5

signal died

@onready var scoreText = $"../CanvasLayer/Label"
var targetPos: Vector3
var velocity: Vector3
var isDead: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		targetPos.x -= event.relative.x * sensitivity #x in inverted
		targetPos.y -= event.relative.y * sensitivity #y is inverted
		targetPos.x = clamp(targetPos.x, -_range/2, _range/2)
		targetPos.y = clamp(targetPos.y, -_range/2, _range/2)
	elif event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif event.keycode == KEY_R:
			get_tree().reload_current_scene()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var prev_position = position
	if (isDead):
		return
	position.x = lerp(position.x, targetPos.x, moveLerp * delta)
	position.y = lerp(position.y, targetPos.y, moveLerp * delta)
	position.z += forwardSpeed * delta
	forwardSpeed += speedIncrease * delta;
	
	velocity = position - prev_position
	scoreText.text = str(roundi(position.z/10))
	
	rotation.y = lerp(rotation.y, -velocity.x * tiltAmount, tiltLerp * delta)
	rotation.x = lerp(rotation.x, velocity.y * tiltAmount, tiltLerp * delta)
	
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("obstacle"):
		die()

func die() -> void:
	print("DEAD")
	died.emit()
	isDead = true
