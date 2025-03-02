# 


extends RigidBody3D

# speed: m/s target speed of the body
# strength: force that is exerted on other rigid bodies
# snappy: amount of acceleration for starting or stopping to move

const SPEED = 15.0
const STRENGTH = 20.0
const SNAPPY = 20.0
const JUMP_HEIGHT = 12.05

@onready var jump_speed:float
@onready var slider:CharacterBody3D = get_parent().get_node("Slider")
@onready var right_hand = $Stabilizer/Node3D/XROrigin3D/XRControllerRight
var camera:Node3D # Node that rotates when the mouse is dragged

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# The force that moves other things is the same as the force that accelerates
	# the player. Change the player's mass to adjust her acceleration
	mass = STRENGTH/SNAPPY
	
	var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	jump_speed = sqrt(2 * JUMP_HEIGHT * gravity)
	
	# Capture mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Choose node that the mouse rotates
	# Preferably a Camera3D but a SpringArm3D works too as a 3rd person camera
	for child in $Stabilizer/Node3D/XROrigin3D.get_children():
		if child is XRCamera3D:
			camera = child
			print(child)
			break
		if child is SpringArm3D:
			camera = child

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var input = Vector3.ZERO
	input.x = right_hand.get_vector2("primary").x
	input.z = -right_hand.get_vector2("primary").y
	
	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		input.x += 1
	if Input.is_action_pressed("move_left"):
		input.x -= 1
	if Input.is_action_pressed("move_backward"):
		input.z += 1
	if Input.is_action_pressed("move_forward"):
		input.z -= 1
	
	# Rotate the input vector so that moving forwards is the direction the camera faces
	var v = camera.transform.basis * input
	
	# Get the input vector with the right magnitude without any vertical component
	v.y = 0
	v = SPEED * v.normalized()
	
	# Complicated collision meshes make the rigid body freak out (freezing up on walls)
	# Simplifying the meshes would take work
	
	# To get around doing that work, use a CharacterBody3D's move_and_slide function
	# to adjust the request velocity
	
	# We'll still have to simplify the floor meshes. ie, rectangular prisms only
	# wherever the player might stand
	
	# Setup CharacterBody3D:
	slider.position = position
	slider.velocity = v
	slider.move_and_slide()
	
	# Since the CharacterBody3D tries to slide off of rigid bodies instead of pushing
	# them, don't use the result if its trying to do that
	# Alternate solution: put rigid bodies on a separate layer and have the
	# CharacterBody3D ignore that layer
	var slips = true
	for i in slider.get_slide_collision_count():
		if slider.get_slide_collision(i).get_collider() is RigidBody3D:
			slips = false
			break
	
	# Use result of move_and_slide
	if slips:
		v = slider.velocity
	
	# With another move_and_slide call, the RigidBody3D can tell if its on the floor
	slider.velocity = Vector3.DOWN
	slider.move_and_slide()
	if (Input.is_action_pressed("jump") || right_hand.is_button_pressed("trigger")) && slider.is_on_floor():
		linear_velocity.y = jump_speed
	
	# Apply force in the direction we've calculated, ignoring the vertical component
	v.y = linear_velocity.y
	apply_central_force(STRENGTH*(v-linear_velocity))

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera.rotation.y -= event.relative.x * 0.002
		camera.rotation.x -= event.relative.y * 0.002
		camera.rotation.x = clampf(camera.rotation.x, -PI/2.001, PI/2.001) # no neck breaking
