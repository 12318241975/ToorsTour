extends CSGBox3D

@export var rotationSpeedMax = 0
@export var rotationSpeedMin = 0

var interval = randi_range(1000,10000)
var rotationSpeed = 0
var nextSpeed = 0
var lastTime = 0
var lastSpeed = 0
@onready var player = $"../Playerbody"
@onready var relativePos = position - player.position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotationSpeed = randf_range(rotationSpeedMin, rotationSpeedMax)
	nextSpeed = randf_range(rotationSpeedMin, rotationSpeedMax)
	lastSpeed = rotationSpeed
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.z = player.position.z + relativePos.z
	rotate_z(rotationSpeed * delta)
	if (Time.get_ticks_msec() - lastTime > interval):
		nextSpeed = randf_range(rotationSpeedMin, rotationSpeedMax)
		lastTime = Time.get_ticks_msec()
		lastSpeed = rotationSpeed
		interval = randi_range(3000,10000)
	rotationSpeed = lerp(lastSpeed, nextSpeed, float(Time.get_ticks_msec() - lastTime) / float(interval))	
