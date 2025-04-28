extends CanvasLayer

# Container for the parent node
var node: Node3D
signal loadposition
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



func _on_save_button_pressed() -> void:

	var current_scene = get_tree().current_scene
	var player = current_scene.get_node("Player")  

	# Ensure that the player exists
	if player:
		#var packed_scene = PackedScene.new()

		# Pack the player node into the PackedScene (this saves only the player, not the entire scene)
		
		# Create a dictionary to store the player’s transform (position, rotation, scale)
		var save_data = {
			"player_position": player.global_position,  # Save position 
		}
		print(player.global_position)
		var json_string = JSON.stringify(save_data)

		# Save the JSON string to a file
		var save_path = "user://player_transform_save.json"
		var file = FileAccess.open(save_path, FileAccess.WRITE)
		file.store_string(json_string)  # Write the JSON string to the file
		file.close()


		print("Player transform saved successfully at: ", save_path)
	else:
		print("Player node not found!")



func _on_load_button_pressed() -> void:
	# Load the saved player scene
	var save_path = "user://player_transform_save.json" 

	# Check if the save file exists
	if FileAccess.file_exists(save_path):
		# Load the JSON string from the file
		var file = FileAccess.open(save_path, FileAccess.READ)
		var json_string = file.get_as_text()  # Read the file as text
		file.close()
		var json_instance = JSON.new()
		# Parse the JSON string into a dictionary
		var result = json_instance.parse(json_string)

		print(result)
		var save_data = json_instance.get_data()  # Get the parsed dictionary

		# Retrieve the saved transform data
		var saved_position = save_data["player_position"]
		var position_values = saved_position.split(",")
		saved_position = Vector3(position_values[0].to_float(), position_values[1].to_float(), position_values[2].to_float())
		#var saved_rotation = save_data["player_rotation"]

		# Get the current player node
		var current_scene = get_tree().current_scene
		var player = current_scene.get_node("Player")  # Replace with your actual player path

		# If the player node exists, apply the saved transform
		if player:
			player.global_position = saved_position

		else:
			print("Player node not found!")
	else:
		print("No save file found!")
