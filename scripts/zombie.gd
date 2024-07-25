extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var speed = 300
var is_player_nearby = false
var is_player_in_attack_area = false
var damage = 5

@onready var player = $/root/Main/Player
@onready var main = $/root/Main

@export var health = 100

func _ready():
	$MovementTimer.wait_time = rng.randf_range(1, 5)
	if get_parent().name == "Main":
		main.zombie_count += 1
		# some organized logic needs to be done here

	go_to_random_position()

func _physics_process(_delta):
	if is_player_nearby:
		go_to_player()
		
	$HealthBarContainer.rotation = -1 * rotation
	$HealthBarContainer/HealthBar.value = health
		
	move_and_slide()
	
	if health <= 0:
		var tween = get_tree().create_tween()
		tween.tween_property($Sprite2D, "scale", Vector2(), 0.2)
		tween.tween_callback(die)

func _on_movement_timer_timeout():
	if get_parent().name == "Main":
		if main.zombie_count <= 10:
			go_to_player()
		else:
			if not is_player_nearby:
				if rng.randi_range(0, 4) == 3:
					go_to_player()
				else:
					go_to_random_position()
	else:
		go_to_random_position()

func _on_area_2d_body_entered(body):
	if body == player:
		is_player_nearby = true

func _on_area_2d_body_exited(body):
	if body == player:
		is_player_nearby = false
		go_to_random_position()

func go_to_random_position():
	var random_vector = Vector2(position.x + rng.randf_range(-100.0, 100.0), position.y + rng.randf_range(-100.0, 100.0))
	look_at(random_vector)
	velocity = position.direction_to(random_vector) * speed

func _on_attack_area_body_entered(body):
	if body == player:
		is_player_in_attack_area = true

func _on_attack_area_body_exited(body):
	if body == player:
		is_player_in_attack_area = false

func _on_attack_timer_timeout():
	if is_player_in_attack_area:
		player.health -= damage

func die():
	player.gold += 1
	main.zombie_count -= 1

	queue_free()

func go_to_player():
	if get_parent().name == "Main":
		look_at(player.position)
		velocity = position.direction_to(player.position) * speed
