extends Camera3D
@export var followLerp: float = 10
@export var rotationLerp: float = 3.0

@onready var player = $"../Playerbody"
@onready var relativePos = position - player.position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = lerp(position, player.position + relativePos, followLerp * delta)
	var targetRotation = player.rotation
	
	var direction = player.position - position
	var targetBasis = Basis.looking_at(direction)
	basis = lerp(basis, targetBasis, rotationLerp * delta)
