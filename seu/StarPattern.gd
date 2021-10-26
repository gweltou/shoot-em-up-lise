extends _BulletPattern
class_name StarPattern



func _init(t , b : Bullet).(t, b):
	pass


func _ready():
	pass # Replace with function body.


func _process(delta):
	if self.delay > 0:
		self.delay -= delta
	else:
		var angle_step = 2 * PI / self.number
		for i in range(self.number):
			self._thrower.shoot(self._bullet.copy(), self.angle)
			self.angle += angle_step
		.queue_free()
