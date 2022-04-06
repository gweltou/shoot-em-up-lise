extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	timer += delta
	if timer > 5:
		get_tree().change_scene("res://title/TitleScreen.tscn")
