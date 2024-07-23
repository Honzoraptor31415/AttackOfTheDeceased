extends Node2D

@onready var tree_scene = preload("res://scenes/tree.tscn")
@onready var zombie_scene = preload("res://scenes/zombie.tscn")

var rng = RandomNumberGenerator.new()

const min_x = -2385
const max_x = 1213
const min_y = -1990
const max_y = 1406

func _ready():
	for i in range(15):
		var tree_instance = tree_scene.instantiate()
		tree_instance.position = Vector2(rng.randf_range(min_x, max_x), rng.randf_range(min_y, max_y))
		tree_instance.rotation = rng.randi_range(0, 360)
		
		var random_scale = rng.randf_range(0.6, 1.1)
		tree_instance.scale.x = random_scale
		tree_instance.scale.y = random_scale
		add_child(tree_instance)

	for i in range(10):
		var zombie_instance = zombie_scene.instantiate()
		zombie_instance.position = Vector2(rng.randf_range(min_x, max_x), rng.randf_range(min_y, max_y))
		add_child(zombie_instance)

func _process(_delta):
	pass
