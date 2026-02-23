extends CharacterBody3D

@export var speed: float = 15.0
@export var limit_z: float = 7.0 

@export var up_action: String = "move_up"
@export var down_action: String = "move_down"

@onready var mesh: MeshInstance3D = $MeshInstance3D

func _ready():
	var mat = mesh.get_active_material(0)
	if mat:
		mesh.set_surface_override_material(0, mat.duplicate())

func _physics_process(_delta):
	var direction = Input.get_axis(up_action, down_action)
	
	if direction:
		velocity.z = direction * speed
	else:
		velocity.z = move_toward(velocity.z, 0, speed)

	velocity.x = 0
	velocity.y = 0
	
	move_and_slide()
	
	global_position.z = clamp(global_position.z, -limit_z, limit_z)
	
func _on_ball_hit():
	var mat = $MeshInstance3D.get_active_material(0)
	var tween = create_tween()
	
	tween.tween_property(mat, "emission_energy_multiplier", 10.0, 0.05)
	tween.tween_property(mat, "emission_energy_multiplier", 2.0, 0.2)
