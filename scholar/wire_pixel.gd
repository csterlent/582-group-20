extends Area3D

var neighbors:Array = []
var depth = 0

var blockable = true
var blocked = false
var active = false

static var allofus = []
static var first = null
static var last
func _ready() -> void:
	allofus.append(self)
	if first == null:
		first = self
	last = self
	
# Signal handler for when a body enters the area
func _on_body_entered(body):
	if body.name == "PlayerBody" and body.global_position.y < 10:
		get_parent().lock_door()
	if blockable and body is RigidBody3D:
		blocked = true
		update()

# Signal handler for when a body exits the area
func _on_body_exited(body):
	if blockable:
		blocked = false
		for obj in get_overlapping_bodies():
			if obj is RigidBody3D:
				blocked = true
		update()

func set_as_root():
	blockable = false
	$MeshInstance3D.visible = false

var holder = null
static var id = 0
func update():
	for pix in allofus:
		pix.active = false
	first.spread()
	for pix in allofus:
		pix.get_node("MeshInstance3D").visible = pix.active

	if last.active:
		holder.now_solved()
	else:
		holder.now_unsolved()

func spread():
	if !blocked:
		active = true
		for pix in neighbors:
			if !pix.active:
				pix.spread()

func addNeighbor(pix):
	neighbors.append(pix)
	pix.neighbors.append(self)
	update()
