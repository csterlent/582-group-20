extends SubViewport


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


@export var painting : MeshInstance3D
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Camera3D.global_transform = painting.get_node("Camera3D").global_transform
