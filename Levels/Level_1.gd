extends Node2D

func _physics_process(delta: float) -> void:
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	$Player.infinite()
