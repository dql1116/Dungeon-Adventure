extends KinematicBody2D

var hit = 2



func _physics_process(_delta: float) -> void:
	position.x = get_node("/root/LevelTemplate/Player").position.x
	position.y = get_node("/root/LevelTemplate/Player").position.y
	






func _on_Area2D_body_entered(body: Node) -> void:
	if body.get_name() != "Player" && body.get_name() != "TileMap":
		hit -= 1
		if hit == 0:
			queue_free()
	


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.get_name() == "ProjectileArea":
		hit -= 1
		if hit == 0:
			queue_free()
