extends Node2D


onready var player = $Player
onready var kelenner = $Kelenner
onready var colleague = $Colleague
onready var letterCollector = $LetterCollector
onready var scoreBar = $ScoreBar


# Called when the node enters the scene tree for the first time.
func _ready():
	letterCollector.connect("add_score", scoreBar, "_on_add_score")
	letterCollector.connect("add_score", colleague, "_on_add_score")
	letterCollector.connect("letter_collected", player, "_on_letter_collected")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
