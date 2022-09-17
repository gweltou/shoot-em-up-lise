extends AbstractLaser
class_name LaserBeam


export var aim := Vector2()
var hitval : int


# Called when the node enters the scene tree for the first time.
func _ready():
	self.direction = aim.normalized()
	self.max_length = aim.length()
	self.cast_to = end
	self.line.points[1] = end
	self.beam_particles.position = start
	self.beam_particles.emitting = false


func _process(delta):
	if hint_active:
		self.beam_particles.position += self.direction * self.speed * delta
		if self.beam_particles.position.length_squared() > self.max_length * self.max_length:
			self.beam_particles.emitting = false
			hint_active = false
			emit_signal("reached_destination")


func _physics_process(delta: float) -> void:
	if self.enabled:
		var forward = self.direction * self.speed * delta
		if end.length_squared() < self.length * self.length:
			end += forward
		else:
			start += forward
			end += forward
		
		self.cast_to = end.clamped(self.max_length)
		var offset = Vector2(randi()%4, randi()%4)
		self.line.points[0] = start + offset
		self.line.points[1] = self.cast_to + offset
		
		force_raycast_update()

		if is_colliding():
			var point = get_collision_point()
			var collider = get_collider()
			print(point)

		
		if end.length_squared() >= self.max_length * self.max_length:
			if start.length_squared() >= self.max_length * self.max_length:
				self.line.visible = false
				self.enabled = false
				emit_signal("beam_ended", self)


func go() -> void:
	hint_active = true
	self.beam_particles.emitting = true
	var timer = .get_tree().create_timer(self.hint_time, false)
	yield(timer, "timeout")
	self.enabled = true
	
