extends KinematicBody2D
class_name Player


const MAX_MOVE_SPEED = 350
var move_speed = MAX_MOVE_SPEED


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _draw():
	var r = $CollisionShape2D.shape.radius
	draw_circle(Vector2(0, 0), r, Color(0, 0, 1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(_delta):
	var vel = Vector2()
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
	if Input.is_action_pressed("move_down"):
		vel.y += 1
	if Input.is_action_pressed("move_left"):
		vel.x -= 1
	if Input.is_action_pressed("move_right"):
		vel.x += 1
	
	move_and_slide(vel.normalized() * move_speed)
#	for i in range(get_slide_count() - 1):
#		var collision = get_slide_collision(i)
#		print(collision.collider.name)


func _on_letter_collected(num_letters : int):
	move_speed = MAX_MOVE_SPEED * max(0.33, (50.0 - num_letters) / 50.0)
