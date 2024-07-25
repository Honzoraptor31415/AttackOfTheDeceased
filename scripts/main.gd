extends Node2D

@onready var tree_scene = preload("res://scenes/tree.tscn")
@onready var zombie_scene = preload("res://scenes/zombie.tscn")
@onready var zombie_count_indicator = $Player/UI/CenterContainer/Grid/ZombiesCountIndicator
@onready var wave_number_indicator = $Player/UI/CenterContainer/Grid/WaveIndicator
@onready var shop_ui = $Player/UI/ShopUIContainer
@onready var buy_wand_button = $Player/UI/ShopUIContainer/Control/Panel/HBoxContainer/WandItem/Button
@onready var buy_med_kit_button = $Player/UI/ShopUIContainer/Control/Panel/HBoxContainer/MedKitItem/Button
@onready var wand_item_label = $Player/UI/ShopUIContainer/Control/Panel/HBoxContainer/WandItem/Label
@onready var med_kit_item_label = $Player/UI/ShopUIContainer/Control/Panel/HBoxContainer/MedKitItem/Label
@onready var med_kit_count_indicator = $Player/UI/Control/MedKitNumberIndicator
@onready var notification_label = $Player/UI/Notification
@onready var notification_timer = $Player/UI/Notification/Timer

@export var zombie_count = 0
@export var wave_number = 1
@export var min_x = -2385
@export var max_x = 1213
@export var min_y = -1990
@export var max_y = 1406
@export var shop_coordinates = {
	start_x = -515,
	start_y = -305,
	end_x = 515,
	end_y = 495
}
@export var is_shop_ui_open = false
@export var med_kit_item_prize = 5

var rng = RandomNumberGenerator.new()
var is_wave_being_created = false
var zombies_per_wave = 15
var is_player_near_cashier = false
var is_mouse_hovering_cashier = false
var wand_item_prize = 20

func _ready():
	for i in range(15):
		var tree_instance = tree_scene.instantiate()
		tree_instance.position = Vector2(get_safe_random_x(), get_safe_random_y())
		tree_instance.rotation = rng.randi_range(0, 360)
		
		var random_scale = rng.randf_range(0.6, 1.1)
		tree_instance.scale.x = random_scale
		tree_instance.scale.y = random_scale
		add_child(tree_instance)
	
	buy_wand_button.pressed.connect(buy_better_wand)
	buy_med_kit_button.pressed.connect(buy_med_kit)

	spawn_zombies()
	
	notification_timer.timeout.connect(hide_notification)

func _physics_process(_delta):
	zombie_count_indicator.text = "Zombies remaining: " + str(zombie_count)
	wave_number_indicator.text = "Wave: " + str(wave_number)
	
	if zombie_count == 0:
		new_wave()
		
	wand_item_label.text = "Better wand: " + str(wand_item_prize) + " Gold"
	med_kit_item_label.text = "Medkit: " + str(med_kit_item_prize) + " Gold"
	med_kit_count_indicator.text = str($Player.med_kit_count)

func spawn_zombies():
	for i in range(zombies_per_wave):
		var zombie_instance = zombie_scene.instantiate()
		zombie_instance.position = Vector2(get_safe_random_x(), get_safe_random_y())
		add_child(zombie_instance)

func new_wave():
	if is_wave_being_created :
		return
	
	is_wave_being_created = true
	if zombies_per_wave < 30:
		zombies_per_wave += 10

	wave_number += 1
	spawn_zombies()
	
	is_wave_being_created = false

func get_safe_random_x():
	var x = rng.randi_range(min_x, max_x)
	if x >= shop_coordinates.start_x and x <= shop_coordinates.end_x:
		return get_safe_random_x()
	return x
	
func get_safe_random_y():
	var y = rng.randi_range(min_y, max_y)
	if y >= shop_coordinates.start_y and y <= shop_coordinates.end_y:
		return get_safe_random_y()
	return y

func _on_cashier_mouse_entered():
	$Shop/Cashier/HoverCircle.visible = true
	is_mouse_hovering_cashier = true
	
func _on_cashier_mouse_exited():
	$Shop/Cashier/HoverCircle.visible = false
	is_mouse_hovering_cashier = false

func _on_area_2d_body_entered(body):
	if body == $Player:
		is_player_near_cashier = true

func _on_area_2d_body_exited(body):
	if body == $Player:
		is_player_near_cashier = false
		shop_ui.visible = false
		is_shop_ui_open = false

func _input(event):
	if event.is_action_pressed("interact") and is_player_near_cashier and is_mouse_hovering_cashier:
		shop_ui.visible = true
		is_shop_ui_open = true
		
	if event.is_action_pressed("escape") and is_shop_ui_open:
		shop_ui.visible = false 
		is_shop_ui_open = false
	
	if event.is_action_pressed("heal"):
		if $Player.med_kit_count > 0 and $Player.health <= 70:
			$Player.health += 30
			$Player.med_kit_count -= 1
		elif $Player.med_kit_count > 0 and $Player.health > 70:
			set_notification("Your health must be less than 70 to heal")
		elif $Player.med_kit_count == 0:
			set_notification("No medkits")

func buy_better_wand():
	if $Player.gold >= wand_item_prize:
		$Player.gold -= wand_item_prize
		$Player.damage += 5
		wand_item_prize += 20
		set_notification("Wand upgraded")
	else:
		set_notification("Not enough gold")
	
func buy_med_kit():
	if $Player.gold >= med_kit_item_prize:
		if $Player.med_kit_count < 30:
			$Player.gold -= med_kit_item_prize
			$Player.med_kit_count += 1
			set_notification("+1 Medkit")
		else:
			set_notification("You have too many medkits")
	else:
		set_notification("Not enough gold")

func set_notification(text):
	notification_label.text = text
	notification_label.visible = true
	notification_timer.start()
	
func hide_notification():
	notification_label.visible = false
	notification_label.text = ""
