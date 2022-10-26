extends KinematicBody2D


func _on_PlayerHit2_area_entered(area: Area2D) -> void:
	if area.get_name() == "AttackArea" || area.get_name() == "PlayerProjectile":
		queue_free()


func _on_EnemyHit2_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		body.damage()
		body.jumpCountMax()
