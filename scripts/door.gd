extends StaticBody2D

@onready var player = $/root/Main/Player

var can_player_open = false
var is_open = false

func _input(event):
	if can_player_open and event.is_action_pressed("use"):
		if is_open:
			var tween = get_tree().create_tween()
			tween.tween_property(self, "rotation_degrees", rotation_degrees - 90, 0.2)
			is_open = false
		else:
			var tween = get_tree().create_tween()
			tween.tween_property(self, "rotation_degrees", rotation_degrees + 90, 0.2)
			is_open = true

func _on_area_2d_body_entered(body):
	if body == player:
		can_player_open = true


func _on_area_2d_body_exited(body):
	if body == player:
		can_player_open = false
