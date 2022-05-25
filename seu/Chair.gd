extends Node2D


export(bool) var walk_in

var student : Pupil = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not walk_in:
		return
	
	if student != null and student.stopped:
		remove_child(student)
		$RigidBody2D.add_child(student)
		student.set_owner($RigidBody2D)
		student = null
