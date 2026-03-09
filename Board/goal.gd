extends Area3D

signal goal_scored

func _on_body_entered(body: Node3D) -> void:
	if body.name == "Ball":
		goal_scored.emit()
