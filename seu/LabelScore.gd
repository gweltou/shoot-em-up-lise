extends Label

func _process(_delta):
	text = "Poentoù: " + str(get_owner().get_node("Player").swag)
