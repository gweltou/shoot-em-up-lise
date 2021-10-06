extends Label

func _process(delta):
	text = "buhez: " +  str(get_owner().get_node("Player").buhez)
	
