extends Node2D


func _physics_process(delta: float) -> void:
	$Player.cameraOff()
	
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
	
	var wr = weakref($Boss)
	if (!wr.get_ref()):
		$EndPortal.monitoring = true


