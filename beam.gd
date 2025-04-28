extends MeshInstance3D

@export var locs:Array[NodePath] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(len(locs)):
		var x = MeshInstance3D.new()
		x.mesh = CylinderMesh.new()
		x.mesh.bottom_radius = 0.5
		x.mesh.cap_bottom = true 
		x.mesh.cap_top = true
		var cur:Node3D = get_node(locs[i])
		var st = StaticBody3D.new()
		x.add_child(st)
		x.transform = cur.transform
		x.scale
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
