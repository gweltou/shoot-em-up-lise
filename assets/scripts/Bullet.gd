extends Node2D
class_name Bullet


# Declare member variables here. Examples:
var type = 0
var direction = Vector2(0, 1)  # Normalized vector

var speed = 100
var drag = 0        # Air friction drag, between 0 and 1
var lifetime = 8    # In seconds
var hitval = 0
var radius = 8 setget set_radius
var letter = ""
var homing = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	
	position += direction * speed * delta
	speed = speed * (1 - drag * delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
		
	# Destroy bullet if it goes out of screen space
	elif global_position.x > OS.window_size.x or global_position.x < 0:
		queue_free()
	elif global_position.y > OS.window_size.y or global_position.y < 0:
		queue_free()


func _draw():
	var col = Color(1, 1, 1)
	if hitval > 0:
		col = Color(0, 1, 0)
	elif hitval < 0:
		col = Color(1, 1, 0)
	draw_circle(Vector2(0, 0), radius, col)
	
	if letter != "":
		var font = Control.new().get_font("font")
		draw_string(font, Vector2(-4, 4), letter, Color(0, 0, 0))


func _on_Area2D_body_entered(_body):
	# Destroy bullet if it touches anything else
	queue_free()


func set_radius(r):
	radius = r
	$Area2D/CollisionShape2D.shape.radius = r

func set_letter(l):
	letter = l[0]
	update()     # Redraw bullet


func copy():
	var new_bullet = load("res://assets/scenes/Bullet.tscn").instance()
	new_bullet.type = type
	new_bullet.speed = speed
	new_bullet.drag = drag
	new_bullet.lifetime = lifetime
	new_bullet.hitval = hitval
	new_bullet.radius = radius
	new_bullet.letter = letter
	new_bullet.homing = homing
	return new_bullet
