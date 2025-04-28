extends RigidBody3D

func _ready():
	sleeping = false
	contact_monitor = true
	max_contacts_reported = 10
	# Add debug print to verify settings
	print("Hammer ready, contact monitoring:", contact_monitor)

func _physics_process(delta: float) -> void:
	for body in get_colliding_bodies():
		if body.is_in_group("breakable"):
			print("Hammer hit breakable object:", body.name)
			var parent = body.get_parent()
			if parent and parent.has_method("break_apart"):
				print("Found break_apart method on parent")
				parent.break_apart()
			elif body.has_method("break_apart"):
				body.break_apart()
