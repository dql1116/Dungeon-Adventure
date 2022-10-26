extends Area2D


onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("Key")




func _on_Key2D_body_entered(body: Node) -> void:
	if body.get_name() == "Player":
		body.keycount()
		queue_free()
