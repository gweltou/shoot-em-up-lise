extends Node2D
class_name Kelenner

onready var Bullet = preload("res://seu/Bullet.tscn")
onready var dialog = preload("res://seu/DialogPopup.tscn").instance()
onready var player = get_parent().get_node("Player")
onready var scoreBar = get_parent().get_node("ScoreBar")
onready var letterCollector = get_parent().get_node("LetterCollector")
onready var estrade = get_owner().get_node("Tables/Estrade")


#enum {IDLE, WALKING, PATTERN1}
#var state = IDLE
var destination = Vector2()
var move_time = 0.0
var wait_time = 0.0


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
	add_child(dialog)
	destination = choose_destination()
	randomize()

func _draw():
	var vertices = [Vector2(-12, 0), Vector2(12, 0), Vector2(12, 30), Vector2(-12, 30)]
	draw_colored_polygon(vertices, Color(0, 0, 1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Execute every patterns in queue and remove finished ones
	var new_patterns = []
	for p in patterns:
#		p.update(delta)
		if not p.ended:
			new_patterns.append(p)
	patterns = new_patterns
	
	fire_time -= delta
	if fire_time <= 0:
		if randf() < 0.02:
			fivestar_attack()
			var exclamations = ["Eat my special attack !",
								"Obey your teacher !",
								"MOUAHAHAHAHA",
								"Take this !"]
			dialog.say(exclamations[randi()%len(exclamations)])
			
			#heart_attack(true)
			#double_bullet_attack()
		elif randf() < 0.08:
			var n = randi()%len(words)
			shoot_word(words[n])
		else:
			shoot_random()
		fire_time = FIRE_RATE
	move_time += delta
	
	if move_time > wait_time :
		move_time = 0
		wait_time = rand_range(1.0, 5.0)
		destination = choose_destination()

	
	var to_dest = destination-position
	if to_dest.length_squared() > 2:	# Paouez fival ma'z eo tost tre eus ar pall
		position += to_dest.normalized() * 2   ##finvadenn ar gelenner


func choose_destination():
	var max_x = estrade.position.x + estrade.shape.extents.x
	var min_x = estrade.position.x - estrade.shape.extents.x
	var max_y = estrade.position.y + estrade.shape.extents.y
	var min_y = estrade.position.y - estrade.shape.extents.y
	var new_destination = Vector2()
	randomize()
	new_destination.x = randf() * (max_x - min_x) + min_x
	new_destination.y = randf() * (max_y - min_y) + min_y
	return new_destination


func shoot_random():
	var bullet = Bullet.instance()
	bullet.radius = 5
	bullet.hitval = -1
	bullet.homing = false
	
	var angle = randf() * 2 * PI
	shoot(bullet, angle)


func shoot(bullet : Bullet, angle):
	bullet.global_position = global_position
	bullet.direction = Vector2(cos(angle), sin(angle))
	owner.add_child(bullet)
	bullet.connect("letter_collected", letterCollector, "_on_letter_collected")
	bullet.connect("player_hit", scoreBar, "_on_player_hit")


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


func fivestar_attack():
	var bullet = Bullet.instance()
	bullet.speed = 100
	bullet.hitval = -0.5
	bullet.radius = 6
	bullet.homing = true
	
	var pattern = StarPattern.new(self, bullet)
	pattern.number = 5


func double_bullet_attack():
	var bullet = Bullet.instance()
	bullet.speed = 250
	bullet.drag = 0
	bullet.hitval = -1
	bullet.radius = 8
	
	var pattern = FanPattern.new(self, bullet)
	pattern.number = 2
	pattern.angle_cone = 0.1
	pattern.aimed = true


func heart_attack(aimed : bool):
	var bullet = Bullet.instance()
	bullet.speed = 160
	bullet.drag = 0.3
	bullet.hitval = -0.5
	bullet.radius = 6
	
	var pattern_left = SequencePattern.new(self, bullet)
	pattern_left.number = 16
	pattern_left.angle_step = 0.17
	pattern_left.rate = 0.1
	
	var pattern_right = SequencePattern.new(self, bullet)
	pattern_right.number = 16
	pattern_right.angle_step = -0.17
	pattern_right.rate = 0.1
	
	if aimed:
		pattern_left.aimed = true
		pattern_right.aimed = true
