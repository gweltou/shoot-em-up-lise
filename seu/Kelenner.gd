extends Node2D
class_name Kelenner

onready var Bullet = preload("res://seu/Bullet.tscn")
onready var dialog = preload("res://seu/DialogPopup.tscn").instance()
onready var player = get_parent().get_node("Player")
onready var scoreBar = get_parent().get_node("ScoreBar")
onready var letterCollector = get_parent().get_node("LetterCollector")
onready var estrade = get_owner().get_node("Estrade/CollisionShape2D")


#enum {IDLE, WALKING, PATTERN1}
#var state = IDLE
var destination = Vector2()
var move_time = 0.0
var move_speed = 1.0
var wait_time = 0.0
var timer = 0.0


const FIRE_RATE = 0.3
var fire_time = 0.0
var phrases = [
				"John is in the kitchen",
				"where is Brian",
				"to be or not to be",
				"my tailor is rich",
				"how are you today",
				"hello world",
				"repeat after me",
				"do you like apples",
				"show me your homework"
				]

var exclamations1 = [
					"Settle down please",
					"Please be quiet",
					"Could you sit down, please ?",
					"Why are you still up ?"
					]
					
var exclamations2 = [
					"Eat my special attack !",
					"Obey your teacher !",
					"MOUAHAHAHAHA",
					"Take this !",
					"You little shit !"
					]


# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(dialog)
	destination = choose_destination()
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	
	fire_time -= delta
	if fire_time <= 0:	# keeps behavior on a tempo
		behave()
		fire_time = FIRE_RATE
	move_time +=  delta
	
	if move_time > wait_time :
		move_time = 0
		wait_time = rand_range(1.0, 5.0)
		destination = choose_destination()
	
	
	var to_dest = destination-position
	if to_dest.length_squared() > 2:	# Paouez fival ma'z eo tost tre eus ar pall
		position += to_dest.normalized() * move_speed   ##finvadenn ar gelenner
		$AnimatedSprite.play("walk")
	else:
		$AnimatedSprite.play("idle")


func behave():
	####### First phase #######
	if scoreBar.fake_time > 40:
		move_speed = 0.6
		if randf() < 0.05:
			var n = randi()%len(phrases)
			shoot_word(phrases[n])
		elif randf() < 0.02:
			shoot_random()
			dialog.say(exclamations1[randi()%len(exclamations1)])
	
	####### Second phase #######
	elif scoreBar.fake_time > 30:
		move_speed = 0.8
		if randf() < 0.04:
			var n = randi()%len(phrases)
			shoot_word(phrases[n])
		elif randf() < 0.01:
			fivestar_attack()
		elif randf() < 0.04:
			rifle_attack(4, true)
	
	####### Third phase #######
	elif scoreBar.fake_time > 10:
		move_speed = 1.5
		if randf() < 0.03:
			var n = randi()%len(phrases)
			shoot_word(phrases[n])
		elif randf() < 0.05:
			rifle_attack(9, true)
		elif randf() < 0.01:
			heart_attack(true)
		elif randf() < 0.02:
			shoot_random()
			
	####### Last phase #######
	else:
		move_speed = 3.0
		if randf() < 0.02:
			var n = randi()%len(phrases)
			shoot_word(phrases[n])
		elif randf() < 0.02:
			fivestar_attack()
			dialog.say(exclamations2[randi()%len(exclamations2)])
			
			#heart_attack(true)
			#double_bullet_attack()
		elif randf() < 0.06:
			rifle_attack(9, true)
		elif randf() < 0.02:
			heart_attack(true)
		elif randf() < 0.02:
			wave_attack()



func choose_destination():
	# Teacher choose a new destination do walk to
	var max_x = estrade.position.x + estrade.shape.extents.x
	var min_x = estrade.position.x - estrade.shape.extents.x
	var max_y = estrade.position.y + estrade.shape.extents.y - 20
	var min_y = estrade.position.y - estrade.shape.extents.y - 20
	var new_destination = Vector2()
	new_destination.x = randf() * (max_x - min_x) + min_x
	new_destination.y = randf() * (max_y - min_y) + min_y
	return new_destination


func shoot_random():
	var bullet = Bullet.instance()
	bullet.hitval = -5
	bullet.homing = false
	
	var angle = randf() * 2 * PI
	shoot(bullet, angle)


func shoot(bullet : Bullet, angle):
	bullet.global_position = global_position
	bullet.direction = Vector2(cos(angle), sin(angle))
	bullet.connect("add_score", scoreBar, "_on_add_score")
	bullet.connect("letter_collected", letterCollector, "_on_letter_collected")
	owner.add_child(bullet)


func shoot_letter(letter, angle):
	var bullet = Bullet.instance()
	bullet.letter = letter
	bullet.hitval = 2
	bullet.speed = 60
	bullet.lifetime = 10
	if randf() < 0.1:
		bullet.hitval = 10
		bullet.collected = true
		bullet.size *= 1.5
	shoot(bullet, angle)


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
	bullet.hitval = -15
	bullet.size = 1.2
	bullet.homing = true
	
	var pattern = StarPattern.new(self, bullet)
	pattern.number = 5
	add_child(pattern)


func double_bullet_attack():
	var bullet = Bullet.instance()
	bullet.speed = 250
	bullet.drag = 0
	bullet.hitval = -10
	#bullet.radius = 1
	
	var pattern = FanPattern.new(self, bullet)
	pattern.number = 2
	pattern.angle_cone = 0.1
	pattern.aimed = true
	add_child(pattern)


func rifle_attack(num, aimed):
	var bullet = Bullet.instance()
	bullet.speed = 160
	bullet.drag = 0.1
	bullet.hitval = -5
	bullet.size = 0.8
	
	var pattern = SequencePattern.new(self, bullet)
	pattern.number = num
	pattern.rate = 0.3
	pattern.aimed = aimed
	add_child(pattern)


func wave_attack():
	var bullet = Bullet.instance()
	bullet.hitval = -2
	
	var pattern = WavePattern.new(self, bullet)
	pattern.number = 12
	pattern.duration = 1
	#pattern.aimed = aimed
	add_child(pattern)


func heart_attack(aimed):
	var bullet = Bullet.instance()
	bullet.speed = 160
	bullet.drag = 0.2
	bullet.hitval = -5
	bullet.size = 0.8
	
	var pattern_left = SequencePattern.new(self, bullet)
	pattern_left.number = 14
	pattern_left.angle_step = 0.18
	pattern_left.rate = 0.2
	
	var pattern_right = SequencePattern.new(self, bullet)
	pattern_right.number = 14
	pattern_right.angle_step = -0.18
	pattern_right.rate = 0.2
	
	if aimed:
		pattern_left.aim_once = true
		pattern_right.aim_once = true
	
	add_child(pattern_left)
	add_child(pattern_right)
