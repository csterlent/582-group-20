extends Node

var m_interfaceVr : XRInterface

##
## The headset position at program launch (not yet centered).
##
var m_transformVr : Transform3D

# The distance from the VR hands that objects can be interacted with
var interact_radius = 20

var vr_base: VRBase;

@onready var left_grab_controller: GrabController = GrabController.new()
@onready var right_grab_controller: GrabController = GrabController.new()

@onready var physics_manager: PhysicsManager = $/root/Scene/PhysicsManager


func setup(interface: XRInterface, _vr_base: VRBase) -> void:
	vr_base = _vr_base;
	assert(vr_base != null, "VR Base must be assigned to controller")
		
	m_interfaceVr = interface
	##
	## Disabling VSync is broken for the Quest 3 OpenXR driver, so this will
	## generate an error and probably cause massive flickering.
	## But it's supposed to work, and will be fixed eventually.
	##
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
	get_viewport().use_xr = true
	left_grab_controller.grab_point = vr_base.left_hand
	right_grab_controller.grab_point = vr_base.right_hand
	m_transformVr = XRServer.get_hmd_transform()
	m_interfaceVr.pose_recentered.connect(processOpenXrPoseRecentered)

func get_input_vector() -> Vector3: 
	var vec: Vector2 = vr_base.left_hand_vector()
	return Vector3(vec.x, 0, -vec.y)
	
func is_sprint_pressed() -> bool: 
	return false

func is_jump_pressed() -> bool: 
	return vr_base.left_hand.is_button_pressed("trigger")

func get_interactables(hand: XRController3D) -> Node3D: 
	var handPos := hand.global_position
	
	var shape = SphereShape3D.new()
	shape.radius = interact_radius
	var transform = Transform3D(hand.transform)
	
	var result = physics_manager.cast_shape(
			shape, 
			transform, 
			physics_manager.COLLISION_LAYER.INTERACTABLE, 
			1)

	if len(result) > 1: 
		return result["collider"]
	return null
	
func handle_grab_object(object: Node3D, context):
	if context == PlayerInputController.HAND.RIGHT: 
		right_grab_controller.grab_object(object)
	else: 
		left_grab_controller.grab_object(object)

		
func is_holding_object(context) -> bool:
	if context == PlayerInputController.HAND.RIGHT:  
		return right_grab_controller.grabbed_object != null
	else: 
		return left_grab_controller.grabbed_object != null

func handle_release_object(context):
	if context == PlayerInputController.HAND.RIGHT: 
		right_grab_controller.release_object()
	else:
		left_grab_controller.release_object()

func is_interact_pressed(context) -> bool: 
	if context == PlayerInputController.HAND.RIGHT: 
		return vr_base.right_hand.is_button_pressed("trigger")
	return vr_base.left_hand.is_button_pressed("trigger")
	
func processOpenXrPoseRecentered():
	XRServer.center_on_hmd(XRServer.RESET_BUT_KEEP_TILT,true)
