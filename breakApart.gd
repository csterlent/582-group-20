extends Node3D

func break_apart():
	for static_piece in get_children():
		if static_piece is StaticBody3D:
			var rigid_piece = RigidBody3D.new()
			rigid_piece.transform = static_piece.transform
			add_child(rigid_piece)

			var collision_shape = static_piece.get_node("CollisionShape3D")
			if collision_shape:
				var new_collision = CollisionShape3D.new()
				new_collision.shape = collision_shape.shape
				rigid_piece.add_child(new_collision)

			rigid_piece.gravity_scale = 1
			rigid_piece.freeze = false
			rigid_piece.sleeping = false

			var random_dir = Vector3(randf() - 0.5, randf(), randf() - 0.5).normalized()
			rigid_piece.apply_impulse(Vector3.ZERO, random_dir * 20)

			static_piece.queue_free()

func _ready():
	add_to_group("breakable")
