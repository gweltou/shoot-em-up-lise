extends AbstractKentel


# Called when the node enters the scene tree for the first time.
func _ready():
	#._ready()
	self.kelenner_phases = [0.0, 0.1, 0.4, 0.8, 1.0]
		
	self.dialog = Dialogic.start('k01')
	.add_child(self.dialog)
	self.in_dialog = true
	self.scoreBar.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#._process(delta)
