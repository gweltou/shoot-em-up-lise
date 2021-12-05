extends Node2D


onready var label = $Label
onready var letterSound = $LetterSoundPlayer
onready var wordSound = $WordSoundPlayer

const bonus_words = ["ab"]
var collected := []


signal add_score(points)


# Called when the node enters the scene tree for the first time.
func _ready():
	label.add_font_override("font", GameVariables.bullet_font)
	label.text = ""


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func join_array(arr : Array) -> String:
	var s : String = ""
	for e in arr:
		s += e
	return s


func _on_letter_collected(letter):
	letterSound.play()
	var n = collected.size()
	# Check number of consecutive letters
	var n_consecutive = 0
	if n >= 2:
		for i in range(1, n):
			if collected[-i] == collected[-i-1]:
				n_consecutive += 1
			else: break
	if n_consecutive >= 2 and letter != collected[-1]:
		# Collect consecutive letters bonus
		emit_signal("add_score", (n_consecutive+1) * (n_consecutive+1))
		collected = collected.slice(0, n-n_consecutive-2)
		wordSound.play()
	collected.append(letter)

	var joined : String = join_array(collected)
	for bw in bonus_words:
		if joined.ends_with(bw):
			joined = joined.trim_suffix(bw)
			collected = collected.slice(0, n-len(bw))
			emit_signal("add_score", len(bw) * len(bw))
			wordSound.play()
			break
	label.text = joined.to_upper()
