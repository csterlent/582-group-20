extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_rigid_body_3d_body_entered(body: Node) -> void:
	# check if the nodes we collide with are in breakable group
	var group = body.get_parent()
	print(group)
	if group.is_in_group("breakable"):
		if group.has_method("break_apart"):
			group.break_apart() 
	queue_free()
	pass # Replace with function body.
