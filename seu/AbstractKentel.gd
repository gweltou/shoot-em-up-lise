extends Node2D
class_name AbstractKentel

onready var player = $Player
onready var kelenner = $Kelenner
onready var colleague = $Colleague
onready var letterCollector = $LetterCollector
onready var scoreBar = $ScoreBar
onready var pauseLabel = $TopLayer/PauseLabel

var dialog
var in_dialog

var time := 0.0
var kelenner_phases = []
var kelenner_phase_idx := 0

var Student = preload("res://seu/Pupil.tscn")
var _walking_students = []
onready var _empty_chairs = [$Tables/Chair, $Tables/Chair2, $Tables/Chair3, $Tables/Chair5]


# Called when the node enters the scene tree for the first time.
func _ready():
	for chair in _empty_chairs:
		var student = Student.instance()
		_walking_students.append(student)
		add_child(student)
		student.delay = randf() * 3
		student.set_global_position(Vector2(640, 515))
		student.walk_to(Vector2(480, 515))
		student.walk_to(chair.position)
	
	get_tree().paused = true
	
	letterCollector.connect("add_score", scoreBar, "_on_add_score")
	letterCollector.connect("add_score", colleague, "_on_add_score")
	#letterCollector.connect("letter_collected", player, "_on_letter_collected")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if in_dialog and not is_instance_valid(dialog):
		in_dialog = false
		get_tree().paused = false
		$ScoreBar.visible = true
		$MusicIntro.play()
	
	if not in_dialog and get_tree().paused and fmod(time, 1) < 0.5:
		pauseLabel.visible = true
	else:
		pauseLabel.visible = false
	
	# Update teacher game phase
	if kelenner_phase_idx < len(kelenner_phases) - 1 and 1 - (scoreBar.fake_time / 45.0) > kelenner_phases[kelenner_phase_idx+1]:
		kelenner_phase_idx += 1
		kelenner.phase = kelenner_phase_idx
		$DebugLabel.text = str(kelenner_phase_idx)
	
	# Students walking or sitting
	if not _walking_students.empty():
		var _walking_students_cpy = _walking_students.duplicate()
		var _empty_chairs_cpy = _empty_chairs.duplicate()
		for i in range(len(_walking_students)):
			var student = _walking_students[i]
			if student.stopped:
				var chair = _empty_chairs[i].get_node("RigidBody2D")
				remove_child(student)
				chair.add_child(student)
				chair.mass += 20	# Chair gets heavier when someone's sitting on it
				student.set_owner(chair)
				student.position = Vector2(0, -5)
				student.rotation = 0
				_walking_students_cpy.remove(i)
				_empty_chairs_cpy.remove(i)
				pass
		_walking_students = _walking_students_cpy
		_empty_chairs = _empty_chairs_cpy
	
	if Input.is_action_just_pressed("ui_pause"):
		get_tree().paused = not get_tree().paused
	
	if Input.is_action_just_pressed("ui_cancel") and not in_dialog and get_tree().paused:
		get_tree().change_scene("res://title/TitleScreen.tscn")
		


func _on_MusicIntro_finished():
	$MusicMainLoop.play()
