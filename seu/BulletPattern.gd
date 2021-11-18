extends Node
class_name _BulletPattern


var _thrower
var _bullet : Bullet
var angle = PI * 0.5				# Start angle of pattern
var number = 4						# Number of bullets in pattern
var aimed = false					# Pattern is directed towards player
var delay = 0						# Delay before start of pattern (in seconds)
var _time_counter = 0
var ended = false


func _init(t , b : Bullet):
	self._thrower = t
	self._bullet = b.copy()
	self._thrower.add_child(self)	# Add the pattern to the scene tree


func get_aim():
	if aimed:
		var player = _thrower.get_parent().get_node("Player")
		angle = _thrower.position.angle_to_point(player.position) + PI
	else:
		angle = PI * 0.5