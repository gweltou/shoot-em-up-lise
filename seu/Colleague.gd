extends Node2D


onready var dialog = $DialogPopup
onready var scoreBar = get_parent().get_node("ScoreBar")

const sentences = [
	"Diwall d'an tennoù ruz !",
	"Pak ar re gwer !",
	"Pak ar memes lizherenn\nmeur a wech\nevit ober ur c'hombo"
]
var sentence_idx = 0
var BEHAVE_RATE := 1000
var behave_timer := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var sprite = $Sprite
	remove_child(sprite)
	$Chair/RigidBody2D.add_child(sprite)
	$Chair/RigidBody2D.mass += 20
	sprite.set_owner($Chair/RigidBody2D)


func _process(delta):	
	behave_timer -= delta
	if behave_timer <= 0:	# keeps behavior on a tempo
		behave()
		behave_timer = BEHAVE_RATE


func behave():
	####### First phase #######
	if scoreBar.fake_time > 40:
		if randf() < 0.5:
			dialog.say(sentences[sentence_idx%len(sentences)])
			sentence_idx += 1
	
	####### Second phase #######
	elif scoreBar.fake_time > 30:
		if randf() < 0.2:
			dialog.say(sentences[sentence_idx%len(sentences)])
			sentence_idx += 1

func _on_add_score(points):
	if points > 20:
		dialog.say("Nice !")
