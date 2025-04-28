extends Node3D

func break_apart():
	# Function called when the column is actually broken
	for static_piece in get_children():
		if static_piece is StaticBody3D:
			var rigid_piece = RigidBody3D.new()
			rigid_piece.transform = static_piece.transform
			get_parent().add_child(rigid_piece)
			rigid_piece.global_position = static_piece.global_position
			rigid_piece.global_rotation = static_piece.global_rotation
			
			# Copy the collision shape
			var collision_shape = static_piece.get_node_or_null("CollisionShape3D")
			if collision_shape:
				var new_collision = CollisionShape3D.new()
				new_collision.shape = collision_shape.shape
				rigid_piece.add_child(new_collision)
			
			# Copy the mesh if available
			var mesh_instance = static_piece.get_node_or_null("MeshInstance3D")
			if mesh_instance:
				var new_mesh = MeshInstance3D.new()
				new_mesh.mesh = mesh_instance.mesh
				new_mesh.material_override = mesh_instance.material_override
				rigid_piece.add_child(new_mesh)
			
			# Setup physics properties
			rigid_piece.gravity_scale = 1
			rigid_piece.freeze = false
			rigid_piece.sleeping = false
			
			# Apply random impulse to break apart
			var random_dir = Vector3(randf() - 0.5, randf(), randf() - 0.5).normalized()
			rigid_piece.apply_impulse(random_dir * 20)
			
			# Remove the old static piece
			static_piece.queue_free()
	
	# Auto-cleanup after a few seconds (optional)
	await get_tree().create_timer(5.0).timeout
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("breakable")
