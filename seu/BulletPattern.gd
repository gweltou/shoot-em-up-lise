extends Node
class_name _BulletPattern


var _thrower
var _bullet : Bullet
var angle = PI * 0.5				# Start angle of pattern
var number = 4						# Number of bullets in pattern
var aimed = false					# Pattern is directed towards player
var aim_once = false
var delay = 0						# Delay before start of pattern (in seconds)
var _time_counter = 0
var ended = false


func _init(t , b : Bullet):
	self._thrower = t
	self._bullet = b.copy()

func _ready():
	if aim_once:
		var player = _thrower.get_parent().get_node("Player")
		self.angle = _thrower.position.angle_to_point(player.position) + PI


func get_aim():
	if aim_once:
		pass
	elif aimed:
		var player = _thrower.get_parent().get_node("Player")
		self.angle = _thrower.position.angle_to_point(player.position) + PI
	else:
		angle = PI * 0.5
