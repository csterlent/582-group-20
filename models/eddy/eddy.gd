extends Node3D

var base_pos : Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_pos = position
	for child in $Node.get_children():
		child.visible = false
	switch_to(0)

var index : int = 0
func switch_to(i):
	$Node.get_node("Layer_" + str(index + 1)).visible = false
	$Node.get_node("Layer_" + str(i + 1)).visible = true
	var x = i % 4
	var y = floor(i / 4)
	position = base_pos + Vector3(-7*x, 9*y, 0)
	index = i

var timer = 0
var mode = 0 # talking, happy, idle, angry
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += 1
	if timer == 200:
		timer = randi_range(0, 150)
		mode = randi_range(0, 3)
	if mode == 0:
		if randi_range(0, 9) == 0:
			switch_to([1, 1, 3, 3, 4, 7].pick_random())
	elif mode == 1:
		if timer % 5 == 0:
			if index != 2:
				switch_to(2)
			elif timer % 20 < 10:
				switch_to(11)
			else:
				switch_to(10)
	elif mode == 2:
		if timer % 10 == 0:
			if randi_range(0, 8) == 0:
				switch_to(5)
			else:
				switch_to(3)
	elif mode == 3:
		switch_to(9)
