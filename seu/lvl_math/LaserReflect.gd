extends AbstractLaser
class_name LaserReflect


#export var angle := PI * 0.5
export var reflect_max_len := 1000
export var bounces = 3

var collision_exceptions := []
var next
var hit_point : Vector2
var hit_point_normal : Vector2
var hitval


# Called when the node enters the scene tree for the first time.
func _ready():
	var space_state = .get_world_2d().direct_space_state
	var start = global_position
	var end = to_global(direction * reflect_max_len)
	var result = space_state.intersect_ray(start, end, collision_exceptions, 2) # Collides with collision layer 2 only
	if result:
		hit_point = to_local(result.position)
		hit_point_normal = result.normal
#		self.line.points[1] = local_endpoint
		max_length = hit_point.length()
#		print(hit_point, hit_point_normal, max_length)
	
	if not result or max_length == 0:
		queue_free()
	
	connect("reached_destination", self, "on_reached_destination")
	go()


func on_reached_destination() -> void:
	if bounces > 0:
		if not hit_point == Vector2.ZERO:
			next = get_script().new()
			next.collision_exceptions = collision_exceptions
			next.direction = direction.bounce(hit_point_normal)
			next.bounces = bounces - 1
			next.translate(hit_point + hit_point_normal * 2)
			next.connect("beam_ended", self, "on_beam_ended")
			add_child(next)
#	else:
#		emit_signal("beam_ended")


func on_beam_ended(beam : LaserReflect):
	if beam.bounces == 0:
		queue_free()
	else:
		emit_signal("beam_ended", beam)


func copy() -> LaserReflect:
	return get_script().new()
