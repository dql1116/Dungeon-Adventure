extends Area2D

var direction = false
var startingPosition = 0
var lifespan = 200

func init(d, ls = 200):
	direction = d
	lifespan = ls

func _physics_process(_delta: float) -> void:
	if startingPosition == 0:
		startingPosition = position.x
	if direction:
		if position.x < startingPosition - lifespan:
			queue_free()
		else:
			position.x -= 18
			scale.x = -1
			
	else:
		if position.x > startingPosition + lifespan:
			queue_free()
		else:
			position.x += 18
			scale.x = 1
	





func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()


func _on_PlayerProjectile_area_entered(area: Area2D) -> void:
	if area.get_name() == "PlayerHit" || area.get_name() == "AttackHit":
		queue_free()




func _on_PlayerProjectile_body_entered(body: Node) -> void:
	if body.get_name() == "TileMap" || body.get_name() == "Boss":
		queue_free()
