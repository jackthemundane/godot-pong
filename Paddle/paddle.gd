extends CharacterBody3D

@export var speed: float = 15.0
@export var limit_z: float = 7.0 
@export var up_action: String = "move_up"
@export var down_action: String = "move_down"
@export var is_ai: bool = false
@export var ai_speed: float = 10.0

@onready var mesh: MeshInstance3D = $MeshInstance3D

var ball: Node3D

func _ready():
	var mat = mesh.get_active_material(0)
	if mat:
		mesh.set_surface_override_material(0, mat.duplicate())

func _physics_process(_delta):
	if get_parent().is_paused:
		return
		
	var direction: float = 0.0
	
	if is_ai and is_instance_valid(ball):
		var distance_to_ball = ball.global_position.z - global_position.z
		
		if abs(distance_to_ball) > 0.2:
			direction = sign(distance_to_ball)
			
		if direction:
			velocity.z = direction * ai_speed
		else:
			velocity.z = move_toward(velocity.z, 0, ai_speed)
			
	else:
		direction = Input.get_axis(up_action, down_action)
		
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
