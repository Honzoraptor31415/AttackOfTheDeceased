extends Area2D

const speed = 700
const damage = 10

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_end_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("zombies"):
		body.health -= damage
		queue_free()
