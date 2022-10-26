extends Area2D



func _on_EndPortal_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
			get_tree().change_scene("res://Levels/End.tscn")
