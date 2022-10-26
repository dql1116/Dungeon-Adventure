extends KinematicBody2D

var player = null
var move = Vector2.ZERO
var speed = 3
var gravity = 3000

var hit = false

func knockback(body):
	while hit:
		position.x -= body.position.x - position.x
		yield(get_tree().create_timer(0.01), "timeout")
		hit = false
	speed = 0
	yield(get_tree().create_timer(1), "timeout")
	speed = 4

func _physics_process(delta: float) -> void:
	move = Vector2.ZERO
#	move.y += gravity * delta
	 
	if player != null:
		move = position.direction_to(player.position) * speed
	else:
		move = Vector2.ZERO
		
	move = move.normalized()
	move = move_and_collide(move * speed)

func _on_PlayerDetector_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		player = body


func _on_EnemyHit_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		hit = true
		knockback(body)
		body.jumpCountMax()
		body.damage()
		if body.health == 0:
#			body.hpReset()
			body.respawn()
			get_tree().reload_current_scene()


func _on_PlayerHit_area_entered(area: Area2D) -> void:
	if area.get_name() == "AttackArea" || area.get_name() == "PlayerProjectile":
		queue_free()
