extends CanvasLayer

# Container for the parent node
var node: Node3D

# Keeps track of whether the pause menu can be resumed
# This is set to true, when ESC has been released after being
# pressed in the parent node
# If we didn't do this, the pause menu would immediately resume
# because both instances recognize the ESC key is down
var can_resume: bool = false

func _ready() -> void:
	# Start by ensuring the pause menu is hidden
	hide()

# Resume the game by hiding the pause menu and unpausing the parent node's tree
func resume() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
	can_resume = true
	node.get_tree().paused = false

# Pause game by showing the menu and pausing the parent node's tree
func pause() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()
	can_resume = false
	node.get_tree().paused = true

func _on_resume_button_pressed() -> void:
	resume()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
