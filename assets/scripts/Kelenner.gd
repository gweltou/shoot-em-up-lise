extends Node2D
class_name Kelenner

onready var Bullet = preload("res://assets/scenes/Bullet.tscn")
onready var player = get_parent().get_node("Player")

#enum {IDLE, WALKING, PATTERN1}
#var state = IDLE

const FIRE_RATE = 0.3
var fire_time = 0.0
var words = ["John is in the kitchen",
			 "silence !", "please",
			 "repeat after me",
			 "please be quiet",
			 "settle down please", "ok that's enough",
			 "do you like apples ?", "show me your homework"]

var patterns = []

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _draw():
	var vertices = [Vector2(-12, -10), Vector2(12, -10), Vector2(12, 30), Vector2(-12, 30)]
	draw_colored_polygon(vertices, Color(0, 0, 1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Execute every patterns in queue and remove finished ones
	var new_patterns = []
	for p in patterns:
		p.update(delta)
		if not p.ended:
			new_patterns.append(p)
	patterns = new_patterns
	
	fire_time -= delta
	if fire_time <= 0:
		if randf() < 0.1:
			heart_attack(true)
		elif randf() < 0.1:
			var n = randi()%len(words)
			shoot_word(words[n])
		else:
			shoot_random()
		fire_time = FIRE_RATE


func shoot_random():
	var bullet = Bullet.instance()
	bullet.radius = 9
	bullet.hitval = -1
	
	var angle = randf() * 2 * PI
	shoot(bullet, angle)


func shoot(bullet : Bullet, angle):
	bullet.global_position = global_position
	bullet.direction = Vector2(cos(angle), sin(angle))
	owner.add_child(bullet)


func shoot_letter(letter, angle):
	var bullet = Bullet.instance()
	bullet.global_position = global_position
	bullet.direction = Vector2(cos(angle), sin(angle))
	bullet.hitval = 0.5
	bullet.speed = 60
	bullet.set_letter(letter)
	owner.add_child(bullet)


func shoot_word(word):
	var angle_step = 0.2
	var angle = PI * 0.5 + (len(word)-1) * 0.5 * angle_step
	for l in word:
		if l != ' ':
			shoot_letter(l, angle)
		angle -= angle_step


func heart_attack(aimed : bool):		
	var bullet = Bullet.instance()
	bullet.speed = 160
	bullet.drag = 0.3
	bullet.hitval = -0.5
	bullet.radius = 6
	
	var pattern_left = Pattern.new(self, bullet)
	pattern_left.number = 16
	pattern_left.angle_step = 0.17
	pattern_left.rate = 0.1
	
	var pattern_right = Pattern.new(self, bullet)
	pattern_right.number = 16
	pattern_right.angle_step = -0.17
	pattern_right.rate = 0.1
	
	if aimed:
		pattern_left.aimed = true
		pattern_right.aimed = true
	
	patterns.append(pattern_left)
	patterns.append(pattern_right)


## Pattern attacks
class Pattern:
	var parent : Kelenner
	var bullet : Bullet
	var rate = 0.2		# Rate of fire (in seconds)
	var number = 4		# Number of bullets in pattern
	var angle = PI * 0.5	# Start angle of pattern
	var angle_step = 0.2	# Angle between each bullet
	var delay = 0			# Delay before start of pattern (in seconds)
	var aimed = false setget set_aimed
	var time_counter = 0
	var ended = false
	
	func _init(parent : Kelenner, b : Bullet):
		self.parent = parent
		self.bullet = b.copy()
	
	func set_aimed(v):
		aimed = v
		if aimed:
			var player = parent.get_parent().get_node("Player")
			angle = parent.position.angle_to_point(player.position) + PI
		else:
			angle = PI * 0.5
	
	func update(delta):
		if delay > 0:
			delay -= delta
		else:
			time_counter += delta
			if time_counter >= rate:
				parent.shoot(bullet.copy(), angle)
				number -= 1
				angle += angle_step
				time_counter = 0
				if number <= 0:
					ended = true
