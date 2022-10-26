extends Node2D





func _on_Area2D_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		body.respawn()
		get_tree().reload_current_scene()
