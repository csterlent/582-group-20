extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@onready var locked = preload("res://models/lobby/locked.wav")
func interact(hand):
	if !$AudioStreamPlayer3D.is_playing():
		$AudioStreamPlayer3D.global_position = hand.global_position
		$AudioStreamPlayer3D.stream = locked
		$AudioStreamPlayer3D.play()
	return null
