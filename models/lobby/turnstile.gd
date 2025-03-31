extends MeshInstance3D

@export var left_version:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@onready var slide = preload("res://models/lobby/slide.wav")
func sound(hand):
	if left_version and !$AudioStreamPlayer3D.is_playing():
		$AudioStreamPlayer3D.global_position = hand.global_position
		$AudioStreamPlayer3D.stream = slide
		$AudioStreamPlayer3D.play()
	return null

var x = 0

@onready var pos = position
@onready var body = get_parent().get_parent().get_node("TestTicket")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (Vector3(31.5, 12, -10.5) - body.global_position).length() < 2:
		if x == 0:
			sound(body)
		x += 0.04
	else:
		if x == 3:
			sound(body)
		x -= 0.1
	if (x < 0):
		x = 0
	if (x > 3):
		x = 3
	if (left_version):
		position = pos + Vector3(0, -x, 0)
	else:
		position = pos + Vector3(0, x, 0)
