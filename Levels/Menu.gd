extends Control

func _physics_process(delta: float) -> void:
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()


func _on_StartButton_pressed() -> void:
	 get_tree().change_scene("res://Levels/Level_1.tscn")


func _on_Quit_pressed() -> void:
	get_tree().quit()
