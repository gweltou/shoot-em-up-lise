extends _BulletPattern
class_name SequencePattern


var rate = 0.2						# Rate of fire (in seconds)
var angle_step = 0.2				# Angle between each bullet


func _init(t , b : Bullet).(t, b):
	pass


func _process(delta):
	if self.delay > 0:
		self.delay -= delta
	else:
		print("pre", angle)
		get_aim()
		print("post", angle)
		self._time_counter += delta
		if self._time_counter >= rate:
			self._thrower.shoot(self._bullet.copy(), self.angle)
			self.number -= 1
			self.angle += angle_step
			self._time_counter = 0
			if self.number <= 0:
				.queue_free()
