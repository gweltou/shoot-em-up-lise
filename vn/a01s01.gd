extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var lang = GameVariables.internal_lang[GameVariables.option_lang]
	var new_dialog = Dialogic.start('mintin bus', '', "res://addons/dialogic/Nodes/DialogNode.tscn", true, lang)
	add_child(new_dialog)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
