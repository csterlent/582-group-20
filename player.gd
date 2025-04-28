extends Node3D

var is_grabbing: bool = false

signal player_jump;
@onready var pause_menu =  get_parent().get_node("PauseMenu")
@onready var input_controller: PlayerInputController = $PlayerInputController
@onready var vr_base = $PlayerBody/Stabilizer/Node3D/VRBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_controller.setup(vr_base.camera, vr_base)
	pause_menu.connect("loadposition", Callable(self, "_on_pause_menu_loadposition"))
 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if input_controller.is_interact_pressed(null): 
		var interactable = input_controller.get_interactables(vr_base.camera)
		if interactable != null && !input_controller.is_holding_object(null):
			input_controller.handle_grab_object(interactable, null)
	else: 
		input_controller.handle_release_object(null)

	
func _physics_process(delta: float) -> void:
	pass

func handle_interact() -> void: 
	pass
	

	
