extends RigidBody3D

var was_moving := false

func _physics_process(delta):
	var moving = linear_velocity.length() > 1
	var hud = get_tree().current_scene.get_node_or_null("Node/instructions/Instructions_label/Label")


	if moving and not was_moving:
		hud.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		hud.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		if hud:
			hud.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			hud.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
			hud.text = "Problem 1\nTwo photons race through an optical loop. One completes a circuit every 0.72 seconds. The other every 0.36 seconds. How many circuits does the faster photon make before they align again at the starting point?\nProblem 2\nA train travels from Station A at a constant speed. If it traveled twice as fast, the journey would take 2 hours less. If it traveled at half its speed, the journey would take 4 hours more. What is the original travel time of the train?\nHint: Use these results with corresponding digits from the letter on the desk."
			hud.visible = true

			await get_tree().create_timer(10.0).timeout
			hud.visible = false
		else:
			print("❌ Could not find instructions/Instructions_label")

	was_moving = moving
