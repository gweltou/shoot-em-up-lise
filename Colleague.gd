extends Node2D


onready var dialog = $DialogPopup

const sentences = [
	"Diwall d'an tennoù ruz !",
	"Pak ar re gwer !",
	"Pak ar memes lizherenn\nmeur a wech\nevit ober un combo"
]
var sentence_idx = 0
var cooldown = 1


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
	cooldown -= delta
	if cooldown <= 0:
		cooldown = 3
		if randf() < 0.2:
			dialog.say(sentences[sentence_idx%len(sentences)])
			sentence_idx += 1
