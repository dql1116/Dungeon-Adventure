extends TextureProgress

var percentage_per_sp: float = 0.0
var speed: float = 0.0

onready var tween: Tween = get_node("Tween")

func _on_Area2D_sp_changed(new_value: int) -> void:
	tween.stop_all()
	
	show()
	tween.interpolate_property(self, "value", value, new_value * percentage_per_sp, speed, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()


func _on_Area2D_recovering_speed_changed(new_speed: float) -> void:
	speed = new_speed


func _on_Area2D_max_sp_changed(new_max) -> void:
	percentage_per_sp = round(100.0/new_max)


func _on_Tween_tween_completed(_object: Object, key: NodePath) -> void:
	hide()
