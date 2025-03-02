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

const branch1 = []
const branch2 = []
const main2 = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var scene = load("res://scholar/wire_pixel.tscn")
	var prev:Area3D
	
	for pair in main1:
		if pair is String:
			continue
			
		var dir = sign(pair[1] - pair[0]);
		var pos = pair[0]
		while pos-dir != pair[1]:
			var inst = scene.instantiate()
			inst.translate(pos + Vector3(15.5, 9.5, 1.5))
			add_child(inst)
			
			if prev:
				prev.neighbors.append(inst)
				inst.neighbors.append(prev)
				#inst.prev_1 = prev
			else:
				beginning = scene.instantiate()
				beginning.set_as_root()
				#inst.prev_1 = beginning
			prev = inst
			pos += dir
	
	ending = scene.instantiate()
	ending.set_as_root()
	#prev.next_1 = ending
	#ending.prev_1 = prev
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
