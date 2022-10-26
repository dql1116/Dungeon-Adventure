extends KinematicBody2D


var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var player = null
var speed = 6

func _ready():

	look_vec = player.position - global_position
	look_at(player.global_position)

func _physics_process(_delta):
	move = Vector2(speed, 0).rotated(rotation)
	move = move_and_collide(move)


func _on_ProjectileArea_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		queue_free()
		body.damage()
		if body.health == 0:
#			body.hpReset()
			body.respawn()
			get_tree().reload_current_scene()
