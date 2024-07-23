extends CharacterBody2D

@export var speed = 400
@export var health = 100

@onready var health_bar = $UI/HealthBar
@onready var bullet_scene = preload("res://scenes/bullet.tscn")

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _input(event):
	if event.is_action_pressed("click"):
		shoot()

func _physics_process(_delta):
	get_input()
	move_and_slide()
	look_at(get_global_mouse_position())
	health_bar.value = health

func shoot():
	var bullet_instance = bullet_scene.instantiate()
	bullet_instance.position = position
	bullet_instance.transform = transform
	$/root/Main.add_child(bullet_instance)
