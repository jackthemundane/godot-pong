extends CharacterBody3D

@export var speed: float = 15.0
var velocity_vector: Vector3 = Vector3.ZERO
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var impact_light: OmniLight3D = $OmniLight3D
@export var baseline_emission: float = 2.0
@export var baseline_light: float = 0.5

func _ready():
	
	var start_x = [-1, 1].pick_random() 
	var start_z = randf_range(-0.8, 0.8)
	
	var pulse = create_tween().set_loops()
	pulse.tween_property(mesh.get_active_material(0), "emission_energy_multiplier", 3.0, 1.0)
	pulse.tween_property(mesh.get_active_material(0), "emission_energy_multiplier", 1.5, 1.0)
	
	velocity_vector = Vector3(start_x, 0, start_z).normalized() * speed

func _physics_process(delta):
	
	var collision = move_and_collide(velocity_vector * delta)
	
	if collision:
		var collider = collision.get_collider()
		
		if "Paddle" in collider.name:
			var paddle_z = collider.global_position.z
			var relative_hit_z = (global_position.z - paddle_z) / 2.5
			
			var bounce_x = 1.0 if velocity_vector.x < 0 else -1.0
			
			var new_direction = Vector3(bounce_x, 0, relative_hit_z).normalized()
			
			velocity_vector = new_direction * velocity_vector.length()
			
		else:
			velocity_vector = velocity_vector.bounce(collision.get_normal())

		if collider.has_method("_on_ball_hit"):
			collider._on_ball_hit()
		
		trigger_flash()
		
		velocity_vector *= 1.02

func trigger_flash():
	var mat = mesh.get_active_material(0)
	var tween = create_tween().set_parallel(true)
	
	tween.tween_property(mat, "emission_energy_multiplier", 15.0, 0.02)
	tween.chain().tween_property(mat, "emission_energy_multiplier", baseline_emission, 0.2)
	
	tween.tween_property(impact_light, "light_energy", 10.0, 0.02)
	tween.chain().tween_property(impact_light, "light_energy", baseline_light, 0.2)
