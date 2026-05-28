extends Node3D

@export var forwardSpeed: float = 10
@export var speedIncrease: float = 1
@export var sensitivity: float = .5
@export var moveLerp: float = 1
@export var _range: float = 50
@export var tiltAmount: float = 2
@export var tiltLerp: float = 5
@export var levelReturn: float = 1.5

signal died

@onready var scoreText = $"../follow/Node3D2/Label3D"
@onready var speedText = $"../follow/Node3D/Label3D"
#@onready var finalScoreText = $"..CanvasLayer/Label"

var targetPos: Vector3
var velocity: Vector3
var isDead: bool = false

var visual_basis: Basis = Basis.IDENTITY
var pitch_rate: float = 0.0
var roll_rate: float = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		targetPos.x -= event.relative.x * sensitivity
		targetPos.y -= event.relative.y * sensitivity
		targetPos.x = clamp(targetPos.x, -_range/2, _range/2)
		targetPos.y = clamp(targetPos.y, -_range/2, _range/2)
	elif event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif event.keycode == KEY_R:
			get_tree().reload_current_scene()

func _process(delta: float) -> void:
	var prev_position = position
	if isDead:
		return
	position.x = lerp(position.x, targetPos.x, moveLerp * delta)
	position.y = lerp(position.y, targetPos.y, moveLerp * delta)
	position.z += forwardSpeed * delta
	forwardSpeed += speedIncrease * delta

	velocity = position - prev_position
	scoreText.text = str(roundi(position.z / 10))
	speedText.text = str(roundi(velocity.z / delta / 10))

	_update_visual_rotation(delta)

func _update_visual_rotation(delta: float) -> void:
	var bank_angle: float = velocity.x * tiltAmount
	var pitch_angle: float = velocity.y * tiltAmount / 10
	var target_basis = Basis.IDENTITY
	target_basis = target_basis.rotated(Vector3.FORWARD, bank_angle)
	target_basis = target_basis.rotated(Vector3.RIGHT, pitch_angle)
	visual_basis = visual_basis.slerp(target_basis, clamp(tiltLerp * delta, 0.0, 1.0)).orthonormalized()
	transform.basis = visual_basis

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("obstacle"):
		die()

func die() -> void:
	print("DEAD")
	#finalScoreText.visible = true
	#finalScoreText.text = str(roundi(position.z / 10))
	died.emit()
	isDead = true
