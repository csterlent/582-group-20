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

func _process(delta: float) -> void:
	# If the ESC button has been released since being pressed in the parent
	# node (can_resume), and ESC is now pressed again, we resume the game
	if can_resume && Input.is_action_just_pressed("ui_cancel"):
		resume()
		
	# To ensure this instance doesn't also recognize the initial press of
	# ESC we rely on can_resume
	elif !can_resume && Input.is_action_just_released("ui_cancel"):
		can_resume = true

# Resume the game by hiding the pause menu and unpausing the parent node's tree
func resume() -> void:
	print(1)
	hide()
	node.get_tree().paused = false

# Pause game by showing the menu and pausing the parent node's tree
func pause() -> void:
	show()
	can_resume = false
	node.get_tree().paused = true
