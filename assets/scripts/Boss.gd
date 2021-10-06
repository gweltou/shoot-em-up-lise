extends Node2D

onready var Bullet = preload("res://assets/scenes/Bullet.tscn")
onready var LetterBullet = preload("res://assets/scenes/LetterBullet.tscn")

const FIRE_RATE = 0.3
var fire_time = 0.0
var words = ["nann!",
			 "siouloc'h", "peoc'h marplij",
			 "selaouit",
			 "hey!",
			 "dihunit", "kahier kenskrivañ",
			 "n'eo ket echu c'hoazh", "n'eo ket echu ar gentel"]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fire_time -= delta
	if fire_time <= 0:
		if randf() < 0.1:
			var n = randi()%len(words)
			shoot_word(words[n])
		else:
			shoot()
		fire_time = FIRE_RATE

func shoot():
	var bullet = Bullet.instance()
	owner.add_child(bullet)
	bullet.global_position = global_position
	var angle = randf() * 2 * PI
	bullet.direction = Vector2(cos(angle), sin(angle))

func shoot_letter(letter, angle):
	var bullet = LetterBullet.instance()
	bullet.global_position = global_position
	bullet.set_letter(letter)
	bullet.direction = Vector2(cos(angle), sin(angle))
	owner.add_child(bullet)

func shoot_word(word):
	var angle_step = 0.2
	var angle = PI * 0.5 + (len(word)-1) * 0.5 * angle_step
	for l in word:
		if l != ' ':
			shoot_letter(l, angle)
		angle -= angle_step
	
