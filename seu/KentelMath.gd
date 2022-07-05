extends AbstractKentel


# Called when the node enters the scene tree for the first time.
func _ready():
	self.kelenner_phases = [0.0, 0.1, 0.4, 0.8, 1.0]
	self._empty_chairs = [$Tables/Chair, $Tables/Chair2, $Tables/Chair3, $Tables/Chair5]
		
	#self.dialog = Dialogic.start('k01')
	#.add_child(self.dialog)
	self.in_dialog = true
	self.scoreBar.visible = false
