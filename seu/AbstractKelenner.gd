extends Node2D
class_name AbstractKelenner

onready var Bullet = preload("res://seu/Bullet.tscn")
onready var dialog = $DialogPopup
onready var scoreBar = get_parent().get_node("ScoreBar")
onready var letterCollector = get_parent().get_node("LetterCollector")
onready var estrade = get_owner().get_node("Estrade/CollisionShape2D")

#enum {IDLE, WALKING, PATTERN1}
#var state = IDLE
var phase = 0
var destination = Vector2()
var move_time = 0.0
var move_speed = 1.0
var wait_time = 0.0
var timer = 0.0


const FIRE_RATE = 0.3
var fire_time = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
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
	if to_dest.length_squared() > 3:	# Paouez fival ma'z eo tost tre eus ar pall
		position += to_dest.normalized() * move_speed   ##finvadenn ar gelenner
		$AnimatedSprite.play("walk")
	else:
		$AnimatedSprite.play("idle")


func behave():
	print("behave")


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
		bullet.collectable = true
		bullet.size *= 1.5
	shoot(bullet, angle)


func shoot_word(word):
	var angle_step = 0.2
	var angle = PI * 0.5 + (len(word)-1) * 0.5 * angle_step
	for l in word:
		if l != ' ':
			shoot_letter(l, angle)
		angle -= angle_step
