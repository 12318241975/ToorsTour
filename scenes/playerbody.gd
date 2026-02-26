extends Node3D
@export var forwardSpeed: float = 10
@export var sensitivity: float = .5

var targetPos: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	# Check if the event is mouse motion
	if event is InputEventMouseMotion:
		# event.relative is a Vector2 of how much the mouse moved this frame
		targetPos.x += event.relative.x * sensitivity  # left/right
		targetPos.y += event.relative.y * sensitivity  # up/down
	elif event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x = targetPos.x
	position.y = targetPos.y
	position.z += forwardSpeed * delta
