extends Camera3D

var shake_strength: float = 0.0

func _process(delta: float):
	if shake_strength > 0.0:
		# Smoothly reduce the strength down to 0
		shake_strength = lerpf(shake_strength, 0.0, 5.0 * delta)
		
		# Apply a random offset based on the current strength
		h_offset = randf_range(-shake_strength, shake_strength)
		v_offset = randf_range(-shake_strength, shake_strength)

func apply_shake(strength: float = 0.3):
	shake_strength = strength
