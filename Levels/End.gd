extends Control





func _on_StartButton_pressed() -> void:
	get_tree().change_scene("res://Levels/Menu.tscn")


func _on_Quit_pressed() -> void:
	get_tree().quit()
