extends Node

var lang = ["br", "fr"]
var internal_lang = ["INTERNAL", "FRA"]
var option_lang := 0
var arcade_mode = false
var current_score := 0
export var max_score := 0

var option_vibration := true

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
func _process(_delta):
	pass
#	if Input.is_action_just_pressed("quit"):
#		get_tree().quit()
