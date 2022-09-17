extends _BulletPattern
class_name WavePattern

var num_waves = 2
var duration := 1.0
var span = PI / 3		# Max angle of shooting cone/sector. Neg to change side.
var offset = 0

var number_init = 0
var aim_angle = 0.0
var rate : float
var started := false

func _init(t, b).(t, b):
	self.aim_once = true


func _process(delta):
	if started:
		self._time_counter += delta
		if self._time_counter >= rate:
			self.angle = aim_angle + offset
			self.angle += span * sin(PI * float(number) / number_init)
			self._thrower.shoot(self._bullet.copy(), self.angle)
			self._time_counter = 0.0
			number -= 1
			if number <= 0:
				num_waves -= 1
				if num_waves <= 0:
#					_bullet.queue_free()
					queue_free()
				else:
					number = number_init
					span = -span
	
	else:
		self.delay -= delta
		if self.delay <= 0:
			self.rate = duration / number
			self.number_init = number
			self.aim_angle = angle
			started = true
