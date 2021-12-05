extends Node2D


onready var letterCollector = $LetterCollector
onready var scoreBar = $ScoreBar
onready var colleague = $Colleague


# Called when the node enters the scene tree for the first time.
func _ready():
	letterCollector.connect("add_score", scoreBar, "_on_add_score")
	letterCollector.connect("add_score", colleague, "_on_add_score")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
