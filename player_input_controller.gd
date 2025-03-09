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

extends Node

# Assume the player is using Mouse and Keyboard
var current_controller: Node;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var vr_interface = get_vr_interface()
	if vr_interface != null: 
		current_controller = get_node("XRController")
		current_controller.call("setup", vr_interface)
	else: 
		current_controller = get_node("MouseKeyboardController")
		current_controller.call("setup")

func get_input_vector() -> Vector3: 
	return current_controller.call("get_input_vector")
	
func is_jump_pressed() -> bool: 
	return current_controller.call("is_jump_pressed")

func get_vr_interface() -> XRInterface: 
	var m_interfaceVr = XRServer.find_interface("OpenXR")
	if m_interfaceVr == null || !m_interfaceVr.is_initialized(): 
		return null
	return m_interfaceVr
