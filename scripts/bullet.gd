extends Area2D

@onready var rng = RandomNumberGenerator.new()

const speed = 700

func _ready():
	var tween = get_tree().create_tween()
	$Sprite2D.scale = Vector2(0, 0)
	tween.tween_property($Sprite2D, "scale", Vector2(0.1, 0.1), 0.2)
	
	$Shot.volume_db = rng.randf_range(-10, 0)
	$Shot.pitch_scale = rng.randf_range(0.7, 1)

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_end_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("zombies"):
		body.health -= $/root/Main/Player.damage
		queue_free()
	
	if body.is_in_group("destroy_bullets"):
		queue_free()
