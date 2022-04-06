extends Node2D


onready var dialog = $DialogPopup
onready var scoreBar = get_parent().get_node("ScoreBar")

const sentences = [
	"Diwall d'an tennoù ruz !",
	"Pak ar re gwer !",
	"Pak ar memes lizherenn\nmeur a wech\nevit ober ur c'hombo"
]
var sentence_idx = 0
#var cooldown = 1
var BEHAVE_RATE := 5000
var behave_timer := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _draw():
	var shape : RectangleShape2D = $StaticBody2D/CollisionShape2D.get_shape()
	var extents = shape.extents
	var vertices = [Vector2(-extents.x, -extents.y), Vector2(extents.x, -extents.y),
					Vector2(extents.x, extents.y), Vector2(-extents.x, extents.y)]
	draw_colored_polygon(vertices, Color(0, 0, 1))


func _process(delta):	
	behave_timer -= delta
	if behave_timer <= 0:	# keeps behavior on a tempo
		behave()
		behave_timer = BEHAVE_RATE


func behave():
	####### First phase #######
	if scoreBar.fake_time > 40:
		if randf() < 0.2:
			dialog.say(sentences[sentence_idx%len(sentences)])
			sentence_idx += 1
	
	####### Second phase #######
	elif scoreBar.fake_time > 30:
		pass

func _on_add_score(points):
	if points > 20:
		dialog.say("Nice !")
