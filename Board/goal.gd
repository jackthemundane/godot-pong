extends Area3D

@onready var score_sound: AudioStreamPlayer = $ScoreSound

signal goal_scored

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Ball":
		score_sound.play()
		var camera = get_viewport().get_camera_3d()
		if camera and camera.has_method("apply_shake"):
			camera.apply_shake(0.3)
		goal_scored.emit()
