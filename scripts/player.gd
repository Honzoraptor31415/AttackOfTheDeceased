extends CharacterBody2D

var can_attack = true

@export var speed = 400
@export var health = 100
@export var gold = 0
@export var med_kit_count = 0
@export var damage = 10

@onready var health_bar = $UI/HealthBar
@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var rng = RandomNumberGenerator.new()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _input(event):
	if event.is_action_pressed("attack") and not $/root/Main.is_shop_ui_open:
		shoot()

func _physics_process(_delta):
	get_input()
	move_and_slide()
	look_at(get_global_mouse_position())
	health_bar.value = health
	
	$UI/CenterContainer/Grid/GoldIndicator.text = "Gold: " + str(gold)
	
	if velocity.length() > 0 and $WalkingSoundTimer.time_left <= 0:
		$Walking.pitch_scale = rng.randf_range(0.85, 1.3)
		$Walking.play()
		$WalkingSoundTimer.start()
	
	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/you_lose.tscn")

func shoot():
	if can_attack:
		var bullet_instance = bullet_scene.instantiate()
		bullet_instance.position = position
		bullet_instance.transform = transform
		$/root/Main.add_child(bullet_instance)
		can_attack = false
		$AttackTimer.start()

func _on_attack_timer_timeout():
	can_attack = true
