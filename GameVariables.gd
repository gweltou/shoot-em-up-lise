extends Node


const bullet_font_size = 16


var bullet_font = DynamicFont.new()



# Called when the node enters the scene tree for the first time.
func _ready():
	bullet_font.font_data = load("res://assets/Fipps-Regular.otf")
	bullet_font.size = bullet_font_size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
