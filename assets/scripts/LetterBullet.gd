extends Bullet
class_name Letter_Bullet


func _ready() -> void:
	bullet_type = 2

func set_letter(letter):
	$Label.text = letter
