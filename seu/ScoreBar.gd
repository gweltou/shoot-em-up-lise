extends Node2D

var bar_green = preload("res://seu/assets/barHorizontal_green.png")
var bar_yellow = preload("res://seu/assets/barHorizontal_yellow.png")
var bar_red = preload("res://seu/assets/barHorizontal_red.png")

onready var lifebar = $TextureProgress
onready var timer = $Timer
onready var timeLabel = $TimeLabel
onready var scoreLabel = $ScoreLabel
onready var maxScore = $MaxScore

const ROUND_DURATION = 200	# in seconds
var time_penalty = 0.6
var life = 50
var fake_time = 45

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = ROUND_DURATION
	timer.start()
	scoreLabel.text = "0"
	maxScore.text = str(GameVariables.max_score)


func _process(delta):
	life -= delta * time_penalty
	lifebar.texture_progress = bar_green
	if life < lifebar.max_value * 0.7:
		lifebar.texture_progress = bar_yellow
	if life < lifebar.max_value * 0.35:
		lifebar.texture_progress = bar_red
	lifebar.value = life
	fake_time = lerp(0, 45, timer.time_left / ROUND_DURATION)
	var decimal_part = fake_time - floor(fake_time)
	var fake_seconds = lerp(0, 60, decimal_part)	
	timeLabel.text = "%02d:%02d" % [fake_time, fake_seconds]
	
	if life <= 0:
		get_tree().change_scene("res://title/GameOver.tscn")

func _on_add_score(points):
	life = min(life + points, 100)
	if points > 0:
		GameVariables.current_score += points
		scoreLabel.text = str(GameVariables.current_score)
		if GameVariables.current_score > GameVariables.max_score:
			GameVariables.max_score = GameVariables.current_score
			maxScore.text = str(GameVariables.max_score)
			

func _on_Timer_timeout():
	# gounezet !
	if GameVariables.arcade_mode == true:
		time_penalty = 0.7
		pass
	else:
		var lang = GameVariables.internal_lang[GameVariables.option_lang]
		var dialog = Dialogic.start('gounezet', '', "res://addons/dialogic/Nodes/DialogNode.tscn", true, lang)
		get_parent().add_child(dialog)
		get_parent().dialog = dialog
		get_parent().in_dialog = true
		get_parent().get_tree().paused = true
