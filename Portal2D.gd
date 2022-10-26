extends Area2D




func _on_Portal2D_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		if body.door() == true:
			get_tree().change_scene("res://Levels/Level_" + str(int(get_tree().current_scene.name) + 1) + ".tscn")
