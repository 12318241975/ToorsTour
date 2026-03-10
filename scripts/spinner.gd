extends CSGCombiner3D
@export var spinSpeed: float = 5;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate(Vector3.FORWARD, spinSpeed * delta)
