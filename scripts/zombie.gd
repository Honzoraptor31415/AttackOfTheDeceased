extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var speed = 300
var is_player_nearby = false
var is_player_in_attack_area = false

const damage = 5

@onready var player = $/root/Main/Player

@export var health = 100

func _ready():
	$MovementTimer.wait_time = rng.randf_range(1, 5)
	go_to_random_position()

func _physics_process(_delta):
	if(is_player_nearby):
		look_at(player.position)
		velocity = position.direction_to(player.position) * speed
	move_and_slide()
	
	if(health <= 0):
		player.score += 1
		queue_free()

func _on_movement_timer_timeout():
	if(not is_player_nearby):
		go_to_random_position()

func _on_area_2d_body_entered(body):
	if(body == player):
		is_player_nearby = true

func _on_area_2d_body_exited(body):
	if(body == player):
		is_player_nearby = false
		go_to_random_position()

func go_to_random_position():
	var random_vector = Vector2(position.x + rng.randf_range(-100.0, 100.0), position.y + rng.randf_range(-100.0, 100.0))
	look_at(random_vector)
	velocity = position.direction_to(random_vector) * speed

func _on_attack_area_body_entered(body):
	if(body == player):
		is_player_in_attack_area = true

func _on_attack_area_body_exited(body):
	if(body == player):
		is_player_in_attack_area = false


func _on_attack_timer_timeout():
	if(is_player_in_attack_area):
		player.health -= damage
