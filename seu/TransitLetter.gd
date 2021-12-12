extends Node2D


# Declare member variables here. Examples:
# var a = 2
var letter := '' setget set_letter
var start : Vector2
var destination : Vector2
var arrived := false
var _vel : Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = start
	_vel = Vector2(randf()*2 - 1, randf()*2 - 1)
	_vel *= 10


func _process(delta : float):
	var dist := (destination - global_position)
	var _acc := dist * delta
	_vel += _acc
	_vel *= 0.9
	position += _vel
	
	if dist.length_squared() < 1:
		arrived = true


func _draw():
	if letter != "":
		var font = GameVariables.bullet_font
		var offset = GameVariables.bullet_font_size / 2.0
		draw_circle(Vector2(0, 0), 8, Color(0, 1, 0, 0.8))
		draw_string(font, Vector2(-offset, offset), letter, Color(0, 0, 0, 0.8))


func set_letter(l):
	letter = l
	update()     # Redraw bullet
