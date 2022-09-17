extends RayCast2D
class_name AbstractLaser


var laserBeamParticles = preload("ressources/Particles_LaserBeam.tres")
var particleGlowTexture = preload("ressources/Texture_GlowingCircle.tres")
var lineTexture = preload("ressources/Texture_Laser.tres")

export var speed := 600.0
export var length := 400.0
export var hint_time := 0.6

var line : Line2D
var beam_particles : Particles2D
var direction : Vector2
var max_length : float
var hint_active := false
var start : Vector2
var end : Vector2


signal reached_destination()
signal beam_ended(sender)


func _ready():
	z_index = 1
	
	line = Line2D.new()
	line.texture_mode = Line2D.LINE_TEXTURE_STRETCH
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	line.default_color = Color( 1, 1, 1, 1 )
	line.texture = lineTexture
	line.add_point(Vector2(0, 0))
	line.add_point(Vector2(0, 0))
	line.visible = false
	add_child(line)
	
	beam_particles = Particles2D.new()
	beam_particles.amount = 48
	beam_particles.randomness = 0.33
	beam_particles.local_coords = false
	beam_particles.process_material = laserBeamParticles
	beam_particles.texture = particleGlowTexture
	add_child(beam_particles)


func _process(delta):
	if hint_active:
		beam_particles.position += direction * speed * delta
		if beam_particles.position.length_squared() > max_length * max_length:
			beam_particles.emitting = false
			hint_active = false
			emit_signal("reached_destination")


func _physics_process(delta: float) -> void:
	if enabled:
		var forward = direction * speed * delta
		if end.length_squared() < length * length:
			end += forward
		else:
			start += forward
			end += forward
		
		cast_to = end.clamped(max_length)
		var offset = Vector2(randi()%4, randi()%4)
		line.points[0] = start + offset
		line.points[1] = cast_to + offset
		
		force_raycast_update()
		
		if is_colliding():
			var point = get_collision_point()
			var collider = get_collider()
			print(point)
		
		
		if end.length_squared() >= max_length * max_length:
			if start.length_squared() >= max_length * max_length:
				line.visible = false
				enabled = false
				emit_signal("beam_ended", self)


func go() -> void:
	hint_active = true
	beam_particles.emitting = true
	var timer = get_tree().create_timer(hint_time, false)
	yield(timer, "timeout")
	line.visible = true
	enabled = true
