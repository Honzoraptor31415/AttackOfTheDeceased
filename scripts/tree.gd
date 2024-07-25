extends AnimatableBody2D

@onready var rng = RandomNumberGenerator.new()

func _on_area_2d_body_entered(body):
	if get_parent().name == "Main" and not body.is_in_group("ignore_trees"):
		body.position = Vector2(rng.randf_range($/root/Main.min_x, $/root/Main.max_x), rng.randf_range($/root/Main.min_y, $/root/Main.max_y))

func get_safe_random_x():
	var x = rng.randi_range($/root/Main.min_x, $/root/Main.max_x)
	if x >= $/root/Main.shop_coordinates.start_x and x <= $/root/Main.shop_coordinates.end_x:
		return get_safe_random_x()
	return x
	
func get_safe_random_y():
	var y = rng.randi_range($/root/Main.min_y, $/root/Main.max_y)
	if y >= $/root/Main.shop_coordinates.start_y and y <= $/root/Main.shop_coordinates.end_y:
		return get_safe_random_y()
	return y
