extends KinematicBody2D

var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var player = null
var speed = 5

func _ready():

	look_vec = player.position - global_position
	look_at(player.global_position)

func _physics_process(_delta):
	move = Vector2(speed, 0).rotated(rotation)
	move = move_and_collide(move)
	
	
#	move = Vector2.ZERO
#
#	move = move.move_toward(look_vec, delta)
#	move  = move.normalized() * speed
#	position += move



func _on_Area2D_body_entered(body: Node) -> void:
	if body.get_name() == "TileMap":
		queue_free()
	
	if body.get_name() == "Player":
		queue_free()
		body.damage()
		if body.health == 0:
#			body.hpReset()
			body.respawn()
			get_tree().reload_current_scene()


func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.get_name() == "Area2D":
		queue_free()
