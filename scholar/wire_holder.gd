extends Node

var beginning:Area3D
var ending:Area3D

const main1 = [
	[Vector3(-4, 6, 14), Vector3(-2, 6, 14)],
	[Vector3(-1, 6, 14), Vector3(-1, 5, 14)],
	[Vector3(0, 5, 13), Vector3(0, 5, -4)],
	"Junction 0",
	[Vector3(0, 4, -4), Vector3(0, 0, -4)],
	[Vector3(0, 0, -5), Vector3(0, 0, -8)],
	[Vector3(0, -1, -8), Vector3(0, -8, -8)],
	[Vector3(-1, -9, -8), Vector3(-3, -9, -8)],
	"Junction 1",
	[Vector3(-3, -9, -7), Vector3(-3, -9, 0)],
	[Vector3(-3, -9, 1), Vector3(-3, -1, 1)],
	[Vector3(-3, -1, 2), Vector3(-3, -1, 9)],
	[Vector3(-2, -1, 9), Vector3(1, -1, 9)],
	[Vector3(0, 0, 9), Vector3(0, 0, 13)],
	[Vector3(0, 0, 9), Vector3(0, 0, 13)],
	[Vector3(-1, 0, 14), Vector3(-4, 0, 14)],
]

const branch = [
	[Vector3(0, 5, -5), Vector3(0, 5, -6)],
	[Vector3(0, 6, -6), Vector3(0, 18, -6)],
	[Vector3(0, 18, -7), Vector3(0, 18, -16)],
	[Vector3(-1, 18, -17), Vector3(-11, 18, -17)],
	[Vector3(-11, 19, -17), Vector3(-16, 19, -17)],
	[Vector3(-17, 19, -17), Vector3(-17, 17, -17)],
	[Vector3(-17, -3, -17), Vector3(-17, -8, -17)],
	[Vector3(-17, -9, -16), Vector3(-17, -9, -8)],
	[Vector3(-16, -9, -8), Vector3(-4, -9, -8)],
]

const main2 = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var prev:Area3D
	var junction:Area3D
	beginning = scene.instantiate()
	beginning.holder = self
	beginning.set_as_root()
	beginning.active = true
	
	for pair in main1:
		if pair is String:
			if junction != null:
				junction.addNeighbor(prev)
			else:
				junction = prev
				for bair in branch:
					junction = trace(bair, junction)
			continue
		prev = trace(pair, prev)
		
		
	
	ending = scene.instantiate()
	ending.set_as_root()
	prev.addNeighbor(ending)
	get_parent().get_node("Painting").visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var scene = load("res://scholar/wire_pixel.tscn")
func trace(pair, prev):
	var dir = sign(pair[1] - pair[0]);
	var pos = pair[0]
	while pos-dir != pair[1]:
		var inst = scene.instantiate()
		inst.holder = self
		var mos = pos
		var t = pos.x
		pos.x = -pos.z
		pos.z = t
		inst.translate(pos + Vector3(15.5-17, 9.5, 1.5+14) + get_parent().global_position)
		add_child(inst)
		pos = mos
		
		if prev:
			prev.addNeighbor(inst)
		else:

			inst.addNeighbor(beginning)
		prev = inst
		pos += dir
	return prev
