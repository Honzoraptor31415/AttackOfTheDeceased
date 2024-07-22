extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var speed = 300
var is_player_nearby = false

@onready var movement_timer = $MovementTimer
@onready var player = $/root/Main/Player

func _ready():
	pass

func _physics_process(_delta):
	if(is_player_nearby):
		look_at(player.position)
		velocity = position.direction_to(player.position) * speed
	move_and_slide()


func _on_movement_timer_timeout():
	var random_vector = Vector2(rng.randf_range(-100.0, 100.0), rng.randf_range(-100.0, 100.0))
	if(not is_player_nearby):
		look_at(random_vector)
		velocity = position.direction_to(random_vector) * speed

func _on_area_2d_body_entered(body):
	if(body == player):
		is_player_nearby = true

func _on_area_2d_body_exited(body):
	if(body == player):
		is_player_nearby = false
