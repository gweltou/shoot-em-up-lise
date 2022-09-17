extends Node2D

var Beam = preload("LaserBeam.gd")

var origin = Vector2.ZERO
var prevBeam : LaserBeam = null
var n_beam := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	var width : int = get_viewport().get_visible_rect().size[0]
#	var height : int = get_viewport().get_visible_rect().size[1]
#	randomize()
#	for i in range(12):
#		add_point(Vector2(randi()%width, randi()%height))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func add_point(point: Vector2) -> void:
	n_beam += 1
	var newBeam = Beam.new()
	newBeam.connect("beam_ended", self, "on_beam_ended")
	newBeam.aim = to_local(point) - origin
	newBeam.translate(origin)
	origin = to_local(point)
	add_child(newBeam)
	if prevBeam == null:
		# First beam will start
		newBeam.go()
	else:
		prevBeam.connect("reached_destination", newBeam, "go")
	prevBeam = newBeam


func on_beam_ended(beam : LaserBeam):
	beam.queue_free()
	n_beam -= 1
	if n_beam == 0:
		queue_free()
