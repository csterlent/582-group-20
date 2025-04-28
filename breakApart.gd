# I used godot docs, reddit, claude, and chatgpt to come to this coding conclusion.
extends Node3D
func _ready() -> void:

	# Add debug print
	add_to_group("breakable")
	print(self.name, " added to breakable group")
	print("Groups: ", get_groups())
	print("Has break_apart method: ", has_method("break_apart"))
	print("Children count: ", get_child_count())

	for child in get_children():
		if child is StaticBody3D:
			child.add_to_group("breakable")

	# Print children for debugging
	for child in get_children():
		print("Child: ", child.name, " class: ", child.get_class())
func break_apart():
	print("Break apart function called!")

	var static_pieces = []
	for child in get_children():
		if child is StaticBody3D:
			static_pieces.append(child)

	print("Found ", static_pieces.size(), " static pieces to break")

	if static_pieces.size() == 0:
		# If no static pieces found, try to queue_free the entire object
		print("No static pieces found, removing entire object")
		queue_free()
		return

	for static_piece in static_pieces:
		# Create rigid body replacement
		var rigid_piece = RigidBody3D.new()
		rigid_piece.transform = static_piece.transform
		get_parent().add_child(rigid_piece) # Add to parent instead of self

		# Try to transfer visuals
		for child in static_piece.get_children():
			if child is MeshInstance3D:
				var new_mesh = child.duplicate()
				rigid_piece.add_child(new_mesh)
			elif child is CollisionShape3D:
				var new_collision = CollisionShape3D.new()
				new_collision.shape = child.shape
				rigid_piece.add_child(new_collision)

		# Physics setup
		rigid_piece.gravity_scale = 1
		rigid_piece.mass = 2.0 # Add explicit mass
		rigid_piece.freeze = false
		rigid_piece.sleeping = false

		# Random impulse - stronger force
		var random_dir = Vector3(randf() - 0.5, randf(), randf() - 0.5).normalized()
		rigid_piece.apply_impulse(random_dir * 50) # Increased force

		# Remove original immediately
		static_piece.queue_free()

	# Queue the parent for deletion after a short delay
	await get_tree().create_timer(0.1).timeout
	queue_free()

	print("Break apart completed")
