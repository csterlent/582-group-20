extends RigidBody3D

func _on_body_entered(body: Node) -> void:
	print("Hammer hit:", body.name)
	
	# Check the parent (Pillar Node3D)
	var parent = body.get_parent()
	if parent and parent.is_in_group("breakable") and parent.has_method("break_apart"):
		print("It's breakable! Breaking now.")
		parent.break_apart()
