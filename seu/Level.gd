extends Node2D


onready var player = $Player
onready var kelenner = $Kelenner
onready var colleague = $Colleague
onready var letterCollector = $LetterCollector
onready var scoreBar = $ScoreBar
onready var pauseLabel = $TopLayer/PauseLabel
var dialog
var in_dialog

var counter := 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	
	letterCollector.connect("add_score", scoreBar, "_on_add_score")
	letterCollector.connect("add_score", colleague, "_on_add_score")
	letterCollector.connect("letter_collected", player, "_on_letter_collected")
	
	dialog = Dialogic.start('k01')
	add_child(dialog)
	in_dialog = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	counter += delta
	if in_dialog and not is_instance_valid(dialog):
		in_dialog = false
		get_tree().paused = false
		
	
	if  not in_dialog and get_tree().paused and fmod(counter, 1) < 0.5:
		pauseLabel.visible = true
	else:
		pauseLabel.visible = false
	
	if Input.is_action_just_pressed("ui_pause"):
		get_tree().paused = not get_tree().paused
