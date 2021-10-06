extends Node2D
class_name Bullet

var bullet_type = 1
var speed = 50
var direction = Vector2(0, 1)

func _physics_process(delta):
	position += direction * speed * delta



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position.x > OS.window_size.x or global_position.x < 0:
		queue_free()
	if global_position.y > OS.window_size.y or global_position.y < 0:
		queue_free()



func _on_Area2D_body_entered(_body):
	queue_free()
