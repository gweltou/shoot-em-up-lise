extends Node2D

var bar_green = preload("res://seu/assets/barHorizontal_green.png")
var bar_yellow = preload("res://seu/assets/barHorizontal_yellow.png")
var bar_red = preload("res://seu/assets/barHorizontal_red.png")

onready var scorebar = $TextureProgress
onready var timer = $Timer
onready var timeLabel = $TimeLabel

const ROUND_DURATION = 300	# in seconds
var score = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = ROUND_DURATION
	timer.start()


func _process(delta):
	score -= delta * 0.5
	scorebar.texture_progress = bar_green
	if score < scorebar.max_value * 0.7:
		scorebar.texture_progress = bar_yellow
	if score < scorebar.max_value * 0.35:
		scorebar.texture_progress = bar_red
	scorebar.value = score
	var fake_time = lerp(0, 45, timer.time_left / ROUND_DURATION)
	var decimal_part = fake_time - floor(fake_time)
	var fake_seconds = lerp(0, 60, decimal_part)	
	timeLabel.text = "%02d:%02d" % [fake_time, fake_seconds]


func _on_player_hit(points):
	print("player hit")
	score += points
