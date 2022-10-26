extends KinematicBody2D

var score : int = 0
var health: int = 4
var healthDecrease = 25

var speed : int = 400
var jumpForce : int = -800
var gravity : int = 3000

var on_ground = true
var jumpCount = 0

var vel : Vector2 = Vector2()

onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer

#Sword
var attackNum = 0

#bullet
onready var bullet = preload("res://PlayerProjectile.tscn")
var b
var bulletAmount = 0
var bulletTime = 0
var bulletPressed = false

var timer = null
var bullet_delay = 0.5
var canShoot = true

#Shield
onready var shield = preload("res://ShieldBody.tscn")
var on = true
var s

#Knockback
var knockback = 0

#Animation Damage
var dmg = false

#Key count
var key = 0
var key_sound_played = false

#BackHit
var entered = false



func infinite():
	health += 10000000000000
	healthDecrease = 0

func cameraOff():
	$Camera2D.current = false
	$Camera2D.zoom.x = 1.5
	$Camera2D.zoom.y = 1.5


func door():
	if key == 3:
		return true
	else:
		return false


func keycount():
	key += 1
	$KeyPickup.play()
	


func respawn(): 
	position.x = 90
	position.y = 1668
	health = 4

func attackTimer():
	yield(get_tree().create_timer(5), "timeout")

#func hpDecrease():
#	if health == 2:
#		return
#	else:
#		healthDecrease -= 10
#
#func hpReset():
#	healthDecrease = 40
	

func damage():
#	hpDecrease()
	if $Iframe.time_left > 0:
		return
	$Iframe.start()
	health -= 1
	dmg = true
	while(knockback < 20):
		if entered == true:
			if sprite.flip_h:
				position.x -= 5
				position.y -= 10
				knockback += 1
			else:
				position.x += 5
				position.y -= 10
				knockback += 1
		elif sprite.flip_h:
			position.x += 5
			position.y -= 10
			knockback += 1
		else:
			position.x -= 5
			position.y -= 10
			knockback += 1
				
		yield(get_tree().create_timer(0.01), "timeout")
		jumpCountMax()
		if dmg:
			animation_player.play("Damage")
		$DamageSound.play()
		
#		$PlayerCollision.disabled = true
	knockback = 0
	entered = false
	dmg = false
#	$PlayerCollision.disabled = false
	


func jumpCountMax():
	jumpCount = 1

func shieldUp():
#	if Input.is_action_just_pressed("shield"):
	if on == true:
		s = shield.instance()
#		s.positions(position.x, position.y)
		get_parent().add_child(s)
#		s.global_position = $Position2D2.global_position
	on = false


func shoot(dir):
	if canShoot:
		if sprite.flip_h:
			$Position2D.position.x = -18
		else:
			$Position2D.position.x = 18
		b = bullet.instance()
		b.init(dir)
		get_parent().add_child(b)
		b.global_position = $Position2D.global_position
		canShoot = false
		timer.start()
		

func on_timeout_complete():
	canShoot = true

func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(bullet_delay)
	timer.connect("timeout", self, "on_timeout_complete")
	add_child(timer)


func _process(_delta: float) -> void:
	var LabelNode = get_node("Death Counter/UI/Control/Counter")
	LabelNode.text = str(key)

func _physics_process(delta):
	
	vel.x = 0

	
#	if Input.is_action_just_pressed("shield"):
##		$ShieldArea/ShieldRadius.disabled = false
#		shieldUp()
	
	
	if Input.is_action_pressed("move_left") && dmg == false:
		vel.x -= speed
		
		if is_on_floor():
			animation_player.play("Run")
	if Input.is_action_pressed("move_right") && dmg == false:
		vel.x += speed
		
		if is_on_floor():
			animation_player.play("Run")
		
	vel = move_and_slide(vel, Vector2.UP)
	
	vel.y += gravity * delta
	
	if Input.is_action_just_pressed("jump"):
		if jumpCount < 1:
			jumpCount += 1
			vel.y = jumpForce
			on_ground = false
		
			
	if is_on_floor():
		on_ground = true
		jumpCount = 0
		
		if Input.is_action_pressed("move_left") == false && Input.is_action_pressed("move_right") == false && Input.is_action_pressed("attack") == false && dmg == false:
			animation_player.play("Idle")
		
		if Input.is_action_pressed("attack") && dmg == false:
			if Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
				if vel.x < 0:
					sprite.flip_h = true
				elif vel.x > 0:
					sprite.flip_h = false
				return
			if attackNum < 1:
				animation_player.play("Sword Attack")
				attackNum += 1
			attackTimer()
			attackNum = 0
		
			
		
	if !is_on_floor():
		if Input.is_action_pressed("attack") && dmg == false:
			animation_player.play("AirAttack")
			shoot(sprite.flip_h)
		elif dmg == false:
			animation_player.play("Jump")
	
	
	if vel.x < 0:
		sprite.flip_h = true
		$BackHit.position.x = 9.5
		$AttackArea/AttackBox.position.x = $SwordPosition.position.x
		$AttackArea/AttackBox2.position.x = 3.667
	elif vel.x > 0:
		sprite.flip_h = false
		$BackHit.position.x = -0.3
		$AttackArea/AttackBox.position.x = 17.833
		$AttackArea/AttackBox2.position.x = -3.667

	
		
	
	
	


func _on_Timer_timeout() -> void:
	if Input.is_action_pressed("attack") && bulletPressed == true:
		while(bulletTime < 5):
			shoot(sprite.flip_h)
			bulletTime += 0.5
	bulletPressed = false
	bulletTime = 0



func _on_BackHit_area_entered(area: Area2D) -> void:
	if area.get_name() != "PlayerZone" && area.get_name() != "PlayerDetector":
		entered = true
	


func _on_Iframe_timeout() -> void:
	$TextureProgress.value -= healthDecrease
