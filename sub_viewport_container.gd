extends SubViewportContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

@onready var player = get_parent().get_node("Player").get_node("PlayerBody")
@onready var teardrop = get_parent().get_node("CanvasLayer").get_node("TextureRect")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	teardrop.rotation = -player.vr_base.camera.rotation.y
	$SubViewport/Camera3D.position.x = player.global_position.x
	$SubViewport/Camera3D.position.z = player.global_position.z
	
