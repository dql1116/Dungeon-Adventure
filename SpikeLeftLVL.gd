extends Node2D


func _on_Area2D_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		body.damage()
		body.jumpCountMax()
		if body.health == 0:
			body.respawn()
			get_tree().reload_current_scene()
