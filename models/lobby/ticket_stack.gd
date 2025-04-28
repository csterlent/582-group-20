extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@onready var scene = load("res://models/lobby/lobby_ticket.tscn")

func interact(hand : Object):
	var x = scene.instantiate()
	get_parent().get_parent().get_parent().add_child(x)
	x.global_position = hand.global_position + Vector3(-1, 0, 0)
	return x
