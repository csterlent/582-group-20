extends Area3D

var neighbors:Array = []
var depth = 0

var blockable = true
var blocked = false
var active = true

# Signal handler for when a body enters the area
func _on_body_entered(body):
	if blockable:
		blocked = true
		update()

# Signal handler for when a body exits the area
func _on_body_exited(body):
	if blockable:
		if get_overlapping_bodies().size() == 0:
			blocked = false
		update()

func set_as_root():
	blockable = false
	$MeshInstance3D.visible = false

func update():
	var was = active
	if blockable:
		active = false
		if !blocked:
			for pix in neighbors:
				if pix.active:
					active = true
	
	$MeshInstance3D.visible = active
	if was != active:
		neighbors.all(update)
