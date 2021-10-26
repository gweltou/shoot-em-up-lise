extends KinematicBody2D
class_name Player


const MOVE_SPEED = 250

var swag = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _draw():
	var r = $Area2D/CollisionShape2D.shape.radius
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
	
	move_and_slide(vel.normalized() * MOVE_SPEED)


func _on_Area2D_area_entered(area):
	if area.get_owner() is Bullet:
		var bullet = area.get_owner()
		swag += bullet.hitval
		if bullet.letter != '':
			get_parent().get_node("LabelLetters").text += bullet.letter
