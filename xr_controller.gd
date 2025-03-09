extends Node

var m_interfaceVr : XRInterface

##
## The headset position at program launch (not yet centered).
##
var m_transformVr : Transform3D

@export
var vr_base: Node = null;


func setup(interface: XRInterface) -> void: 
	assert(vr_base != null, "VR Base must be assigned to controller")
		
	m_interfaceVr = interface
	##
	## Disabling VSync is broken for the Quest 3 OpenXR driver, so this will
	## generate an error and probably cause massive flickering.
	## But it's supposed to work, and will be fixed eventually.
	##
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
	get_viewport().use_xr = true
	m_transformVr = XRServer.get_hmd_transform()
	m_interfaceVr.pose_recentered.connect(processOpenXrPoseRecentered)

func get_input_vector() -> Vector3: 
	var vec: Vector2 = vr_base.right_hand_vector()
	return Vector3(vec.x, 0, vec.y)
	
func is_jump_pressed() -> bool: 
	return vr_base.right_hand.is_button_pressed("trigger")
	
func processOpenXrPoseRecentered():
	XRServer.center_on_hmd(XRServer.RESET_BUT_KEEP_TILT,true)
