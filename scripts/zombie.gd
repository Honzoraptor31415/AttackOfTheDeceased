extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var speed = 1

@onready var movement_timer = $MovementTimer
@onready var player = $/root/Main/Player

func _ready():
	pass

func _physics_process(_delta):
	move_and_slide()


func _on_movement_timer_timeout():
	velocity = Vector2(rng.randf_range(-100.0, 100.0), rng.randf_range(-100.0, 100.0)) * speed


func _on_area_2d_body_entered(body):
	print(body)
	
	if(body == player):
		print("Player entered zombies area")
