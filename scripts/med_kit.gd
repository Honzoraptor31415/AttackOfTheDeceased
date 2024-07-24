extends Area2D

@onready var player = $/root/Main/Player

var can_player_use_medkit = false

func _on_body_entered(body):
	if body == player:
		can_player_use_medkit = true

func _on_body_exited(body):
	if body == player:
		can_player_use_medkit = false

func _input(event):
	if event.is_action_pressed("use") and can_player_use_medkit and player.health <= 70:
		player.health += 30
		queue_free()
