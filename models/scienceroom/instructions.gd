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
			hud.text = "Einstein's Quantum Rings\nI have 9 quantum rings that I want to be ordered. How many permutations are there to pick 5 rings?\nHints: formula = n!/(n-r)!     n! = n*(n-1)* . . . 1     9! = 362,880\n Work with the chalk as well then examine the bookshelf."
			hud.visible = true

			await get_tree().create_timer(10.0).timeout
			hud.visible = false
		else:
			print("❌ Could not find instructions/Instructions_label")

	was_moving = moving
