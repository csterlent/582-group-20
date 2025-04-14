extends RigidBody3D

@onready var anim_player: AnimationPlayer = find_child("open_door", true, false)
@onready var trigger_area: Area3D = find_child("Area3D", true, false)

var has_played := false

func _ready():
	if trigger_area:
		trigger_area.body_entered.connect(_on_body_entered)
	else:
		print("❌ Area3D not found")

func _on_body_entered(body: Node3D):
	if not has_played:
		print("💥 Collision detected with:", body.name)
		anim_player.play("door_open")
		has_played = true
