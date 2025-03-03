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

var holder = null
static var id = 0
func update():
	for pix in allofus:
		pix.active = false
	first.spread()
	for pix in allofus:
		pix.get_node("MeshInstance3D").visible = pix.active

	holder.get_parent().get_node("Painting").visible = !last.active

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
