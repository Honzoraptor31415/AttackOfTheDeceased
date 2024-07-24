extends Node2D

@onready var tree_scene = preload("res://scenes/tree.tscn")
@onready var zombie_scene = preload("res://scenes/zombie.tscn")
@onready var med_kit_scene = preload("res://scenes/med_kit.tscn")
@onready var zombie_count_indicator = $Player/UI/CenterContainer/Grid/ZombiesCountIndicator
@onready var wave_number_indicator = $Player/UI/CenterContainer/Grid/WaveIndicator

@export var zombie_count = 0
@export var wave_number = 1

var rng = RandomNumberGenerator.new()
var is_wave_being_created = false
var zombies_per_wave = 15

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

	spawn_zombies()

func _physics_process(_delta):
	zombie_count_indicator.text = "Zombies remaining: " + str(zombie_count)
	wave_number_indicator.text = "Wawe: " + str(wave_number)
	
	if zombie_count == 0:
		new_wave()

func spawn_zombies():
	for i in range(zombies_per_wave):
		var zombie_instance = zombie_scene.instantiate()
		zombie_instance.position = Vector2(rng.randf_range(min_x, max_x), rng.randf_range(min_y, max_y))
		add_child(zombie_instance)

func new_wave():
	if is_wave_being_created :
		return
	
	is_wave_being_created = true
	zombies_per_wave += 10
	wave_number += 1
	spawn_zombies()
	
	is_wave_being_created = false


func _on_med_kit_spawn_timer_timeout():
	var number_of_medkits = 0
	for child in get_children():
		if child.is_in_group("medkits"):
			number_of_medkits += 1
	
	print(number_of_medkits) 
	
	if(number_of_medkits < 30):
		var med_kit_instance = med_kit_scene.instantiate()
		med_kit_instance.position = Vector2(rng.randf_range(min_x, max_x), rng.randf_range(min_y, max_y))
		add_child(med_kit_instance)
