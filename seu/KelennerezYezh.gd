extends AbstractKelenner


var sentences = [
				"John is in the kitchen",
				"where is Brian",
				"to be or not to be",
				"my tailor is rich",
				"how are you today",
				"hello world",
				"repeat after me",
				"do you like apples",
				"show me your homework"
				]

var exclamations1 = [
					"Settle down please",
					"Please be quiet",
					"Could you sit down, please ?",
					"Why are you still up ?"
					]

var exclamations2 = [
					"This is my last warning",
					"You're a pain in the ass !",
					"Unteachable brat !",
					"You wanna go see the headmaster ?",
					"And where is your pencil case ?",
					"Have you forgot your eraser again ?",
					"Are you listening to what I say ?"
					]

var exclamations3 = [
					"Eat my special attack !",
					"Obey your teacher !",
					"MOUAHAHAHAHA",
					"Take this !",
					"You little shit !"
					]


func behave():
	####### First phase #######
	if self.phase == 0:
		self.move_speed = 0.6
		if randf() < 0.05:
			var n = randi() % len(sentences)
			.shoot_word(sentences[n])
		elif randf() < 0.02:
			.shoot_random()
			self.dialog.say(exclamations1[randi()%len(exclamations1)])
	
	####### Second phase #######
	elif self.phase == 1:
		self.move_speed = 0.8
		if randf() < 0.04:
			var n = randi()%len(sentences)
			.shoot_word(sentences[n])
		elif randf() < 0.01:
			fivestar_attack()
		elif randf() < 0.04:
			rifle_attack(4, true)
		elif randf() < 0.02:
			self.dialog.say(exclamations2[randi()%len(exclamations2)])
	
	####### Third phase #######
	elif self.phase == 2:
		self.move_speed = 1.5
		if randf() < 0.03:
			var n = randi()%len(sentences)
			.shoot_word(sentences[n])
		elif randf() < 0.05:
			rifle_attack(9, true)
		elif randf() < 0.01:
			heart_attack(true)
		elif randf() < 0.02:
			.shoot_random()
		elif randf() < 0.02:
			self.dialog.say(exclamations2[randi()%len(exclamations2)])
			
	####### Last phase #######
	else:
		self.move_speed = 3.0
		if randf() < 0.02:
			var n = randi()%len(sentences)
			.shoot_word(sentences[n])
		elif randf() < 0.02:
			fivestar_attack()
			self.dialog.say(exclamations3[randi()%len(exclamations3)])
			#heart_attack(true)
			#double_bullet_attack()
		elif randf() < 0.06:
			rifle_attack(9, true)
		elif randf() < 0.02:
			heart_attack(true)
		elif randf() < 0.02:
			wave_attack()


##
## Attack Patterns
##

func fivestar_attack():
	var bullet = Bullet.instance()
	bullet.speed = 100
	bullet.hitval = -15
	bullet.size = 1.2
	bullet.homing = true
	
	var pattern = StarPattern.new(self, bullet)
	pattern.number = 5
	.add_child(pattern)


func double_bullet_attack():
	var bullet = Bullet.instance()
	bullet.speed = 250
	bullet.drag = 0
	bullet.hitval = -10
	#bullet.radius = 1
	
	var pattern = FanPattern.new(self, bullet)
	pattern.number = 2
	pattern.angle_cone = 0.1
	pattern.aimed = true
	.add_child(pattern)


func rifle_attack(num, aimed):
	var bullet = Bullet.instance()
	bullet.speed = 160
	bullet.drag = 0.1
	bullet.hitval = -5
	bullet.size = 0.8
	
	var pattern = SequencePattern.new(self, bullet)
	pattern.number = num
	pattern.rate = 0.3
	pattern.aimed = aimed
	.add_child(pattern)


func wave_attack():
	var bullet = Bullet.instance()
	bullet.hitval = -2
	
	var pattern = WavePattern.new(self, bullet)
	pattern.number = 12
	pattern.duration = 1
	#pattern.aimed = aimed
	.add_child(pattern)


func heart_attack(aimed):
	var bullet = Bullet.instance()
	bullet.speed = 160
	bullet.drag = 0.2
	bullet.hitval = -5
	bullet.size = 0.8
	
	var pattern_left = SequencePattern.new(self, bullet)
	pattern_left.number = 14
	pattern_left.angle_step = 0.18
	pattern_left.rate = 0.2
	
	var pattern_right = SequencePattern.new(self, bullet)
	pattern_right.number = 14
	pattern_right.angle_step = -0.18
	pattern_right.rate = 0.2
	
	if aimed:
		pattern_left.aim_once = true
		pattern_right.aim_once = true
	
	.add_child(pattern_left)
	.add_child(pattern_right)
