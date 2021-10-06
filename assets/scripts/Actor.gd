extends KinematicBody2D
class_name Player

export var speed = 300
var velocity = Vector2()
var buhez = 5
var poentou = 0

func get_input():
	velocity = Vector2()
	if  Input.is_action_pressed("up"):
		velocity.y -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("right"):
		velocity.x += 1

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity.normalized() * speed)
	if buhez == 0 :
		kill()

func _on_Area2D_area_entered(area):
	if area.get_owner() is Bullet:
		var bullet = area.get_owner()
		if bullet.bullet_type == 1 :
			buhez = buhez - 1
		elif bullet.bullet_type == 2 :
			poentou = poentou + 10

func kill():
	queue_free()
