# 


extends RigidBody3D

# speed: m/s target speed of the body
# strength: force that is exerted on other rigid bodies
# snappy: amount of acceleration for starting or stopping to move

const SPEED = 20.0
const STRENGTH = 20.0
const SNAPPY = 20.0
const JUMP_HEIGHT = 12.05

@onready var jump_speed:float
@onready var slider:CharacterBody3D = get_parent().get_node("Slider")
@onready var vr_base = $Stabilizer/Node3D/VRBase

@export
var input_controller: Node = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# The force that moves other things is the same as the force that accelerates
	# the player. Change the player's mass to adjust her acceleration
	mass = STRENGTH/SNAPPY
	
	var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	jump_speed = sqrt(2 * JUMP_HEIGHT * gravity)

func _physics_process(delta):
	# We create a local variable to store the input direction.
	var input: Vector3 = input_controller.get_input_vector()
	
	# Rotate the input vector so that moving forwards is the direction the camera faces
	var v = vr_base.camera.transform.basis * input
	
	# Get the input vector with the right magnitude without any vertical component
	v.y = 0
	v = SPEED * v.normalized()
	if Input.is_action_pressed("sprint"):
		v *= 2
	
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
	if (input_controller.is_jump_pressed() && slider.is_on_floor()):
		linear_velocity.y = jump_speed
	
	# Apply force in the direction we've calculated, ignoring the vertical component
	v.y = linear_velocity.y
	apply_central_force(STRENGTH*(v-linear_velocity))

# REFACTOR: Move this to Mouse and Keyboard Player Controller
func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		vr_base.camera.rotation.y -= event.relative.x * 0.002
		vr_base.camera.rotation.x -= event.relative.y * 0.002
		vr_base.camera.rotation.x = clampf(vr_base.camera.rotation.x, -PI/2.001, PI/2.001) # no neck breaking
