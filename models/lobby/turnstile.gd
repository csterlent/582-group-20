extends MeshInstance3D

@export var left_version:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


@onready var pos = position
@onready var body = get_parent().get_parent().get_node("TestTicket")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var x = 10 - (Vector3(31, 12, -10) - body.global_position).length()
	x *= 0.1;
	if (x < 0):
		x = 0
	if (x > 5):
		x = 5
	if (left_version):
		x *= -1
	position = pos + Vector3(0, x, 0)
