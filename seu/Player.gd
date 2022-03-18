extends KinematicBody2D
class_name Player

var move_speed = 400
var moving = false


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
	
	var l = vel.length_squared()
	if not moving and l > 0:
		$AnimatedSprite.play("default")
		moving = true
	elif moving and l == 0:
		$AnimatedSprite.stop()
		$AnimatedSprite.set_frame(0)
		moving = false
		
	move_and_slide(vel.normalized() * move_speed)
#	for i in range(get_slide_count() - 1):
#		var collision = get_slide_collision(i)
#		print(collision.collider.name)


func hit(hitval):
	if hitval < 0:
		$PlayerHit.play()
	else:
		if $PlayerLetter.is_playing():
			$PlayerLetter2.play()
		else:
			$PlayerLetter.play()
