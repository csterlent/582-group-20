extends RayCast3D
@onready var beam_mesh = $BeamMesh
@onready var end_particles = $endParticles

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.lit:
		beam_mesh.visible = true
		var cast_point
		force_raycast_update()
	
		if is_colliding():
			cast_point = to_local(get_collision_point())
			beam_mesh.mesh.height = cast_point.y
			beam_mesh.position.y = cast_point.y/2
			
			# Position end particles at collision point
			#end_particles.position.y = cast_point.y
	else:
		# Just hide the beam and particles when not lit
		beam_mesh.visible = false
		#end_particles.visible = false
