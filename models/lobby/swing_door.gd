extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


@onready var slide = preload("res://models/lobby/swing.wav")
func sound():
	if !$AudioStreamPlayer3D.is_playing():
		$AudioStreamPlayer3D.global_position = self.global_position
		$AudioStreamPlayer3D.stream = slide
		$AudioStreamPlayer3D.play()
	return null

var ppav = 0
var pav = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	apply_torque(-100*Vector3(0, rotation.y, 0))
	angular_velocity *= 0.99
	var av = angular_velocity.length()
	if (av > 0.1 and av > pav and ppav > pav):
		sound()
	ppav = pav
	pav = av
