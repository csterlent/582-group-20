extends RigidBody3D

@onready var anim_player: AnimationPlayer = find_child("open_bookshelf", true, false)

var was_moving:= false


func _physics_process(delta):
	var moving = linear_velocity.length() > 1

	if moving and not was_moving:
		anim_player.play("new_animation")
	
	was_moving = moving
