extends Node3D

@onready var player = $"../Playerbody"
@onready var relativePos = position - player.position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.z = player.position.z + relativePos.z
