"""
A controller class which abstracts actions from the 
physical implementation. 
i.e., exists as a layer of abstraction to interface with 
the player's hardware

For example, passes signals to more fine-tuned and specific 
controllers based on the type of controller the Player is 
using: 
	Mouse and Keyboard
	VR Headset
"""

class_name PlayerInputController extends Node3D

enum CONTROLLER {MouseKeyboard, VR}
enum HAND {LEFT, RIGHT}

var CUR_CONTROLLER: CONTROLLER
var _current_controller: Node;

func setup(camera: Camera3D, context): 
	var vr_interface = get_vr_interface()
	if vr_interface != null: 
		_current_controller = get_node("XRController")
		_current_controller.call("setup", vr_interface, context)
		CUR_CONTROLLER = CONTROLLER.VR
	else: 
		_current_controller = get_node("MouseKeyboardController")
		_current_controller.call("setup", camera)
		CUR_CONTROLLER = CONTROLLER.MouseKeyboard

func get_input_vector() -> Vector3: 
	return _current_controller.call("get_input_vector")

func is_sprint_pressed() -> bool: 
	return _current_controller.is_sprint_pressed()

func is_jump_pressed() -> bool: 
	return _current_controller.is_jump_pressed()

func is_interact_pressed(context) -> bool: 
	return _current_controller.is_interact_pressed(context)

func get_interactables(camera: Node3D) -> Node: 
	return _current_controller.get_interactables(camera)

func is_holding_object(context) -> bool: 
	return _current_controller.is_holding_object(context)

func handle_grab_object(object: Node3D, context) -> void: 
	return _current_controller.handle_grab_object(object, context)

func handle_release_object(context): 
	return _current_controller.handle_release_object(context)

func get_vr_interface() -> XRInterface: 
	var m_interfaceVr = XRServer.find_interface("OpenXR")
	if m_interfaceVr == null || !m_interfaceVr.is_initialized(): 
		return null
	return m_interfaceVr
