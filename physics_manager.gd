class_name PhysicsManager extends Node3D

enum COLLISION_LAYER {
	UNIVERSAL = 1,
	INTERACTABLE = 2
}

func cast_camera_ray(camera: Camera3D, from: Vector3, to: Vector3, collision_layer: int): 
	var space_state := get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = collision_layer;
	return space_state.intersect_ray(query)

func cast_shape(shape: Shape3D, transform: Transform3D, collision_layer: int, max_results: int): 
	var space_state := get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	query.collision_mask = collision_layer
	query.shape = shape
	query.transform = transform
	return space_state.intersect_shape(query, max_results)
