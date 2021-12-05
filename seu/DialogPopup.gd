extends NinePatchRect
class_name DialogPopup

var text : String
var writing : bool = false
var waiting : bool = false
const letterDelay = 0.04
var letterIdx : int = 0
var timeCounter = 0

onready var font = $Label.get_font("font")
onready var tween = $Tween


func _ready():
	hide()
	rect_size = Vector2()
	

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
		# Free itself after a time period depending on text length
		if timeCounter > self.text.length() * 0.1 and not Engine.editor_hint:
			self.visible = false
			

func say(t : String):
	#var toSize = font.get_string_size(t) + Vector2(24, 15)
	var toSize = _get_text_size(t) + Vector2(24, 15)
	self.rect_position = Vector2(-toSize.x / 2, -toSize.y - 10)
	self.text = t
	$Label.text = ""
	self.letterIdx = 0
	self.timeCounter = 0
	self.writing = false
	self.visible = true
	tween.interpolate_property(self, "rect_size", rect_size, toSize, 0.2)
	tween.start()


func _get_text_size(t : String):
	var max_len := 0
	var n = 0
	for l in t.split('\n'):
		n += 1
		max_len = max(max_len, font.get_string_size(l).x)
	return Vector2(max_len, n * (font.get_height() + 2))


func _on_Tween_tween_all_completed():
	writing = true
