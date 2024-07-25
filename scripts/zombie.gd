extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var speed = 300
var is_player_nearby = false
var is_player_in_attack_area = false
var damage = 5
var worth = 1

@onready var player = $/root/Main/Player
@onready var main = $/root/Main

@export var health = 100

func _ready():
	$MovementTimer.wait_time = rng.randf_range(1, 5)
	if get_parent().name == "Main":
		main.zombie_count += 1
		damage += main.wave_number * 2
		
		if main.wave_number >= 2:
			if rng.randi_range(0, 5) == 0:
				scale = Vector2(1.3, 1.3)
				damage += 20
				$AttackTimer.wait_time = 2
				speed -= 100
				health *= 1.5
				worth = 3
				$HealthBarContainer/HealthBar.max_value = health
				$NearbyArea.scale = Vector2(3, 3)
		elif main.wave_number >= 4:
			var random_number = rng.randi_range(0, 5)
			if random_number == 0:
				scale = Vector2(0.7, 0.7)
				damage -= 10
				health *= 0.7
				speed += 300
				worth = 2
				$NearbyArea.scale = Vector2(5, 5)
			if random_number == 1:
				scale = Vector2(1.3, 1.3)
				damage += 20
				$AttackTimer.wait_time = 2
				speed -= 100
				health *= 1.5
				worth = 3
				$HealthBarContainer/HealthBar.max_value = health
				$NearbyArea.scale = Vector2(3, 3)
	
	$ScreamTimer.wait_time = rng.randi_range(10, 30)
	$Scream.volume_db = rng.randf_range(-20, -10)
	$Scream.pitch_scale = rng.randf_range(0.25, 1)

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
	player.gold += worth
	main.zombie_count -= 1

	queue_free()

func go_to_player():
	if get_parent().name == "Main":
		look_at(player.position)
		velocity = position.direction_to(player.position) * speed


func _on_scream_timer_timeout():
	$Scream.play()
	print("Scream")
