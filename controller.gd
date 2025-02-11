extends CharacterBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
@onready var camera:Node3D = get_node("Camera3D")

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var input_x:float
	var input_y:float
	
	var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	var vel_up:float = velocity.y - gravity * delta;
	
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		input_x += 1
	if Input.is_action_pressed("move_left"):
		input_x -= 1
	if Input.is_action_pressed("move_backward"):
		input_y += 1
	if Input.is_action_pressed("move_forward"):
		input_y -= 1
		
	velocity = camera.transform.basis * Vector3(input_x, 0, input_y)
	velocity.y = 0
	velocity = 25 * velocity.normalized()
	
	if Input.is_action_pressed("jump") and is_on_floor():
		var height:float = 10
		vel_up = sqrt(2*height*gravity)
	velocity.y = vel_up
		
	move_and_slide()
	
	#for i in get_slide_collision_count():
		#var collision = get_slide_collision(i)
		#if collision.get_collider() is RigidBody3D:
			#print("!")

# rotate player horizontally when the mouse moves left or right
# disabled when the mouse is not being captured!
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera.rotation.y -= event.relative.x * 0.002
		camera.rotation.x -= event.relative.y * 0.002
		camera.rotation.x = clampf(camera.rotation.x, -PI/2.001, PI/2.001) # no neck breaking
