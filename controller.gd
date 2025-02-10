extends CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var input_x:float
	var input_y:float
	var vel_up:float = velocity.y - 2
	
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		input_x += 1
	if Input.is_action_pressed("move_left"):
		input_x -= 1
	if Input.is_action_pressed("move_backward"):
		input_y += 1
	if Input.is_action_pressed("move_forward"):
		input_y -= 1
	
		
	velocity = 25 * (transform.basis * Vector3(input_x, 0, input_y)).normalized()
	
	if Input.is_action_pressed("jump") and is_on_floor():
		vel_up = 50
	velocity.y = vel_up
		
	move_and_slide()

@onready var camera = get_node("Camera3D")

# rotate player horizontally when the mouse moves left or right
# disabled when the mouse is not being captured!
# accumulators
var rot_x:float = 0
var rot_y:float = 0
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# modify accumulated mouse rotation
		rot_x -= event.relative.x * 0.001
		rot_y -= event.relative.y * 0.001
		rot_y = clampf(rot_y, -PI/2, PI/2) # no neck breaking
		
		transform.basis = Basis() # reset rotation
		camera.transform.basis = Basis()
		
		rotate_y(rot_x) # first rotate in Y
		camera.rotate_x(rot_y) # then rotate in X
