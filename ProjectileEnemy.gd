extends KinematicBody2D

onready var bullet_scene = preload("res://Projectile.tscn")

var player = null
var move = Vector2.ZERO
var speed = 1

var hit = false

func knockback(body):
	while hit:
		position.x -= body.position.x - position.x
		yield(get_tree().create_timer(0.01), "timeout")
		hit = false
	speed = 0
	yield(get_tree().create_timer(1), "timeout")
	speed = 1


func _physics_process(_delta: float) -> void:
	
	move = Vector2.ZERO
	 
	if player != null:
		$Arm.look_at(player.global_position)
		move = position.direction_to(player.position) * speed
	else:
		move = Vector2.ZERO
		
	move = move.normalized()
	move = move_and_collide(move * speed)
		

func _on_Area2D_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		player = body



#func _on_Area2D_body_exited(body: Node) -> void:
#	player = null

func fire():
	var bullet = bullet_scene.instance()
	bullet.position = $Arm/Hand.global_position
	bullet.player = player
	get_parent().add_child(bullet)
	$Timer.set_wait_time(1)

func _on_Timer_timeout() -> void:
	if player != null:
		fire()


func _on_AttackHit_area_entered(area: Area2D) -> void:
	if area.get_name() == "AttackArea" || area.get_name() == "PlayerProjectile":
		queue_free()
		


func _on_EnemyHit_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		hit = true
		knockback(body)
		body.jumpCountMax()
		body.damage()
		if body.health == 0:
			body.respawn()
			get_tree().reload_current_scene()
