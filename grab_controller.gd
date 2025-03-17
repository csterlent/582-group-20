class_name GrabController extends Node3D

var grabbed_object: RigidBody3D = null

var grab_point: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func grab_object(object: Node3D) -> bool: 
	if grabbed_object != null || object == null: 
		return false
	grabbed_object = object
	grabbed_object.freeze = true
	return true
		

func release_object() -> void: 
	if grabbed_object != null: 
		grabbed_object.freeze = false
	grabbed_object = null

func move_object(delta) -> void:
	if grabbed_object == null: return 
	var direction := grabbed_object.global_transform.origin.direction_to(grab_point.global_transform.origin).normalized()
	var distance := grabbed_object.global_transform.origin.distance_to(grab_point.global_transform.origin)
	grabbed_object.linear_velocity = direction * distance * delta;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	move_object(delta)
	
	
