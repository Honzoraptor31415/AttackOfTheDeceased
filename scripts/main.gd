extends Node2D

@onready var tree_scene = preload("res://scenes/tree.tscn")
@onready var zombie_scene = preload("res://scenes/zombie.tscn")

var rng = RandomNumberGenerator.new()

const min_x = -2385
const max_x = 1213
const min_y = -1990
const max_y = 1406

func _ready():
	# place 10 trees around the map randomly
	for i in range(10):
		var tree_instance = tree_scene.instantiate()
		tree_instance.position = Vector2(rng.randf_range(min_x, max_x), rng.randf_range(min_y, max_y))
		add_child(tree_instance)

	# place 10 zombies around the map randomly
	for i in range(10):
		var zombie_instance = zombie_scene.instantiate()
		zombie_instance.position = Vector2(rng.randf_range(min_x, max_x), rng.randf_range(min_y, max_y))
		add_child(zombie_instance)

func _process(_delta):
	pass
