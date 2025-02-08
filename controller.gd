extends CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var input_x:float
	var input_y:float
	
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		input_x += 1
	if Input.is_action_pressed("move_left"):
		input_x -= 1
	if Input.is_action_pressed("move_backward"):
		input_y += 1
	if Input.is_action_pressed("move_forward"):
		input_y -= 1
		
	velocity = 10 * (transform.basis * Vector3(input_x, 0, input_y)).normalized()
	move_and_slide()

@onready var camera = get_node("Camera3D")

# rotate player horizontally when the mouse moves left or right
# disabled when the mouse is not being captured!
func _input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * 0.002)
			#camera.rotate_x(-event.relative.y  * 0.01)
