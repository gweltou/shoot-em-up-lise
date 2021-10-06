extends Label

func _process(delta):
	text = "Poentoù: " + str(get_owner().get_node("Player").poentou)
