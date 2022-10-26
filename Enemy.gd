extends KinematicBody2D


var vel : Vector2 = Vector2()
var speed : int = 200
var gravity : int = 3000

func _ready() -> void:
	set_physics_process(false)
	vel.x = -speed
	
func _physics_process(delta: float) -> void:
	vel.y += gravity * delta
	
	if is_on_wall():
		vel.x *= -1.0
	
	vel.y = move_and_slide(vel, Vector2.UP).y
		
	
 

	


func _on_Sides_area_entered(area: Area2D) -> void:
	if area.get_name() == "AttackArea" || area.get_name() == "PlayerProjectile":
		queue_free()
		



func _on_EnemyHit_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		body.damage()
		body.jumpCountMax()
		if body.health == 0:
			body.respawn()
			get_tree().reload_current_scene()
