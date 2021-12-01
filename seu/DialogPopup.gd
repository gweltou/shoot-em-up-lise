tool
extends NinePatchRect

export var text : String = "Dialog Box" setget set_text
var writing : bool = false
var waiting : bool = false
const letterDelay = 0.06
var letterIdx : int = 0
var timeCounter = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready")
	$Label.text = ""
	var font = $Label.get_font("font")
	self.rect_size = font.get_string_size(self.text) + Vector2(24, 15)
	$AnimationPlayer.play("open_dialog")


func set_text(txt : String):
	print("set_text")
	text = txt
	self.letterIdx = 0
	self.timeCounter = 0
	self.writing = true
	if Engine.editor_hint:
		$Label.text = self.text
		var font = $Label.get_font("font")
		self.rect_size = font.get_string_size(self.text) + Vector2(24, 15)
		writing = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if writing:
		timeCounter += delta
		if timeCounter >= letterDelay:
			timeCounter -= letterDelay
			$Label.text += self.text[letterIdx]
			letterIdx += 1
			if letterIdx >= self.text.length():
				self.writing = false
				self.waiting = true
	if waiting:
		timeCounter += delta
		if timeCounter > self.text.length() * 0.2 and not Engine.editor_hint:
			queue_free()
			

func _on_AnimationPlayer_animation_finished(anim_name):
	writing = true
