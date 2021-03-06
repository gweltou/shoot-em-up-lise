extends Node2D
class_name Bullet


onready var player = get_parent().get_node("Player")


#var type = 0
var direction = Vector2(0, 1)	# Normalized vector
var speed = 100
var drag = 0					# Air friction drag, between 0 and 1
var lifetime = 8				# In seconds
var hitval = 0					# Score added or reduces when player is hit
var size = 1 setget set_size
var letter = '' setget set_letter
var collectable = false
var homing = false				# Bullet follows player


signal add_score(points)
signal letter_collected(letter, pos)


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_STOP


func _physics_process(delta):
	if homing:
		var to_player = player.position - position
		var a = direction.angle_to(to_player) * 0.016
		direction = direction.rotated(a)
	
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
	if collectable:
		col = Color(1, 1, 0)
		draw_circle(Vector2(0, 0), size*8, col)
	elif hitval > 0:
		col = Color(0, 1, 0)
		draw_circle(Vector2(0, 0), size*8, col)
	
	if letter != "":
		$AnimatedSprite.hide()
		var font = GameVariables.bullet_font
		var offset = GameVariables.bullet_font_size / 2.0
		draw_string(font, Vector2(-offset, offset), letter, Color(0, 0, 0))


func _on_Area2D_body_entered(body):
	# Destroy bullet if it touches anything else
	if body.get_name() == "Player":
		emit_signal("add_score", hitval)
		if collectable and self.letter != '':
			emit_signal("letter_collected", letter, global_position)
			queue_free()
		else:
			body.hit(self)
			$Area2D/CollisionShape2D.disabled = true
			if $AnimatedSprite.visible :
				#speed = 0
				$AnimatedSprite.play("default")
			else:
				queue_free()


func set_size(s):
	size = s
	$Area2D.scale = Vector2(s, s)
	$AnimatedSprite.scale = Vector2(s, s)


func set_letter(l):
	letter = l
	update()     # Redraw bullet


func copy():
	var new_bullet = load("res://seu/Bullet.tscn").instance()
	#new_bullet.type = type
	new_bullet.speed = speed
	new_bullet.drag = drag
	new_bullet.lifetime = lifetime
	new_bullet.hitval = hitval
	new_bullet.size = size
	new_bullet.letter = letter
	new_bullet.homing = homing
	new_bullet.collectable = collectable
	return new_bullet


func _on_AnimatedSprite_animation_finished():
	queue_free()
