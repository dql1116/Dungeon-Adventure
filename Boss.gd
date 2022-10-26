extends KinematicBody2D

onready var bullet_scene = preload("res://BossProjectile.tscn")

var vel : Vector2 = Vector2()
var speed : int = 100
var gravity : int = 3000

var player = null

var health = 20
var healthDecrease = 5

var fly = false



func _ready() -> void:
	vel.x = -speed

func _physics_process(delta: float) -> void:
	vel.y += gravity * delta
	if fly == true:
		$Arm.look_at(player.global_position)
	
	if health == 15:
		fly = true
	
	if health == 10:
		fireRate = 0.8
		position.x = 1336
		position.y = 120
		vel.x = 0
	
	if health == 5 :
		position.x = 1336
		position.y = 860
		fireRate = 0.5
		vel.x = 0
		
	if is_on_wall():
			vel.x *= -1.0
	
	
	
	vel.y = move_and_slide(vel, Vector2.UP).y
		

var fireRate = 1

func fire():
	var bullet = bullet_scene.instance()
	bullet.position = $Arm/Hand.global_position
	bullet.player = player
	get_parent().add_child(bullet)
	$Timer.set_wait_time(fireRate)


func _on_PlayerZone_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		player = body


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.get_name() == "AttackArea" || area.get_name() == "PlayerProjectile":
		health -= 1
		$TextureProgress.value -= healthDecrease
		if health == 0:
			queue_free()


func _on_Area2D_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		body.jumpCountMax()
		body.damage()
		if body.health == 0:
			body.respawn()
			get_tree().reload_current_scene()


func _on_Timer_timeout() -> void:
	if fly == true:
		fire()
