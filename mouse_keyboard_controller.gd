extends Node

func setup() -> void: 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func is_jump_pressed() -> bool: 
	return Input.is_action_pressed("jump")

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
	return input_vector
	
