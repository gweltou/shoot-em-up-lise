extends _BulletPattern
class_name FanPattern


var angle_cone = PI / 3			# Angle of shooting cone/sector


func _init(t , b : Bullet).(t, b):
	pass


func _ready():
	pass # Replace with function body.


func _process(delta):
	if self.delay > 0:
		self.delay -= delta
	else:
		get_aim()
		var angle_step = angle_cone / (self.number - 1)
		self.angle -= (self.number - 1) * 0.5 * angle_step
		for _i in range(self.number):
			self._thrower.shoot(self._bullet.copy(), self.angle)
			self.angle += angle_step
		.queue_free()
