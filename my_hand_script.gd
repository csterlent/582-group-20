extends XRController3D

var grabbed_object: RigidBody3D = null

var grab_point: Vector3
var grab_rotation: Vector3
var grab_basis: Basis

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func grab_something() -> bool:
	var object = null
	if $Area3D.has_overlapping_bodies():
		object = $Area3D.get_overlapping_bodies()[0]
	if grabbed_object != null || object == null: 
		return false
	if object.has_method("interact"):
		object = object.interact(self)
		if object == null:
			return false
	grabbed_object = object
	grabbed_object.gravity_scale = 0
	grab_point = grabbed_object.global_position - global_position
	grab_rotation = grabbed_object.rotation - global_rotation
	return true

func release_object() -> void: 
	if grabbed_object != null: 
		grabbed_object.gravity_scale = 1
	grabbed_object = null

func move_object(delta) -> void:
	if grabbed_object == null: return
	var global_grab_point = grab_point + global_position
	var direction := grabbed_object.global_transform.origin.direction_to(global_grab_point).normalized()
	var distance := grabbed_object.global_transform.origin.distance_to(global_grab_point)
	grabbed_object.apply_central_force(1000 * direction * distance);
	#grabbed_object.rotation = grab_rotation + global_rotation
	#grabbed_object.global_position = grab_point + global_position
	grabbed_object.linear_velocity *= 0.5
	grabbed_object.angular_velocity *= 0.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if (tracker == "left_hand" and Input.is_action_pressed("grab_left")) or (tracker == "right_hand" and Input.is_action_pressed("grab_right")):
		if grabbed_object == null:
			grab_something()
	else :
		release_object()
	move_object(delta)
