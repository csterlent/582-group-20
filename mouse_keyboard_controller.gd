extends Node3D

const INTERACT_LENGTH = 15
@onready var physics_manager: PhysicsManager = $/root/Scene/PhysicsManager
@onready var grab_controller: GrabController = GrabController.new()

func setup(camera: Camera3D) -> void: 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	var interact_node = Node3D.new()
	interact_node.position = camera.position + Vector3.FORWARD
	camera.add_child(interact_node)
	#grab_controller.grab_point = interact_node
	

func is_sprint_pressed() -> bool: 
	return Input.is_action_pressed("sprint")

func is_jump_pressed() -> bool: 
	return Input.is_action_pressed("jump")
	
func is_interact_pressed(context) -> bool:
	return false#Input.is_action_pressed("grab")

func get_interactables(camera: Camera3D) -> Node: 
	var mousepos := get_viewport().get_mouse_position()
	
	var start = camera.project_ray_origin(mousepos)
	var end = start + camera.project_ray_normal(mousepos) * INTERACT_LENGTH
	var result = physics_manager.cast_camera_ray(camera, 
					start, end, 
					physics_manager.COLLISION_LAYER.INTERACTABLE)

	if len(result) > 1: 
		return result["collider"]
	return null
	
func handle_grab_object(object: Node3D, context):
	pass#grab_controller.grab_object(object)

func is_holding_object(context) -> bool: 
	return false#grab_controller.grabbed_object != null

func handle_release_object(context):
	#grab_controller.release_object()
	pass

func get_input_vector() -> Vector3:
	var input_vector: Vector3 = Vector3.ZERO 
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_backward"):
		input_vector.z += 1
	if Input.is_action_pressed("move_forward"):
		input_vector.z -= 1
	return input_vector.normalized()
	
