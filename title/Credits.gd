extends Control


func _input(event):
	if event is InputEventKey:
		if not get_tree().is_input_handled():
			get_tree().change_scene("res://title/TitleScreen.tscn")
