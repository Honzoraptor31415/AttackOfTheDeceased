extends Node2D

func _input(event):
	if event.is_action_pressed("menu_enter"):
		get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _physics_process(_delta):
	$PointLight2D.position = get_global_mouse_position()
