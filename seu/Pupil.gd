extends Node2D
class_name Pupil

export var speed : float = 100

var stopped := true
var delay := 0.0

var walk_axe = []
# Axes :
#	0 : x
#	1 : y
var walk_steps = []
var axe : int
var steps : float
var dir : int
var _moving := false
var _current_goal : Vector2


func _ready():
	visible = false
	pass


func _process(delta):
	if not _moving and walk_steps.empty():
		return
	
	if delay > 0.0:
		delay -= delta
		return
	
	if not _moving:
		axe = walk_axe.pop_front()
		steps = walk_steps.pop_front()
		dir = int(sign(steps))
		if axe == 0:
			rotation = dir * PI * 0.5
		elif axe == 1:
			rotation = PI * 0.5 + dir * PI * 0.5
		$AnimatedSprite.play("default")
		_moving = true
		visible = true
	
	var speed_delta = speed * delta
	if abs(steps) < speed_delta:
		if axe == 0:
			position.x += steps
		elif axe == 1:
			position.y += steps
		_moving = false
		$AnimatedSprite.stop()
		if walk_axe.empty():
			stopped = true
	else:
		if axe == 0:
			position.x += dir * speed_delta
		elif axe == 1:
			position.y += dir * speed_delta
		steps -= dir * speed_delta


func walk_to(next_pos : Vector2):
	if walk_axe.empty():
		_current_goal = get_global_position()
	var diff = next_pos - _current_goal
	_current_goal = next_pos
	if diff.y > 1 or diff.y < 1:
		walk_axe.append(1)
		walk_steps.append(diff.y)
	if diff.x > 1 or diff.x < 1:
		walk_axe.append(0)
		walk_steps.append(diff.x)
	stopped = false
