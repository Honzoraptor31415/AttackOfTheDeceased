extends AnimatableBody2D

@onready var rng = RandomNumberGenerator.new()

func _on_area_2d_body_entered(body):
	if get_parent().name == "Main" and not body.is_in_group("ignore_trees"):
		body.position = Vector2(rng.randf_range($/root/Main.min_x, $/root/Main.max_x), rng.randf_range($/root/Main.min_y, $/root/Main.max_y))
