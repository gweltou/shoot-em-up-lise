extends Node


var bullet_font = DynamicFont.new()
const bullet_font_size = 14


# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_font.font_data = load("res://assets/Fipps-Regular.otf")
	bullet_font.size = bullet_font_size
	bullet_font.extra_spacing_char = 2
	bullet_font.extra_spacing_bottom = -12
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
