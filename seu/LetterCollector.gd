extends Node2D


onready var label : Label = $Label
onready var letterSound = $LetterSoundPlayer
onready var wordSound = $WordSoundPlayer
var font : DynamicFont

const TransitLetter = preload("res://seu/TransitLetter.gd")

const bonus_words = ["great", "cool"]
var collected := []
var in_transit := []
var joined : String = ""


signal add_score(points)
signal letter_collected(number)


# Called when the node enters the scene tree for the first time.
func _ready():
	label.add_font_override("font", GameVariables.bullet_font)
	label.text = ""
	font = label.get_font("font")


func _process(_delta):
	if len(in_transit) > 0 and in_transit[0].arrived:
		var transitLetter = in_transit.pop_front()
		remove_child(transitLetter)
		register_letter(transitLetter.letter)
		transitLetter.queue_free()


func join_array(arr : Array) -> String:
	# Return a concatenated string from an array of strings
	var s : String = ""
	for e in arr:
		s += e
	return s


func _on_letter_collected(letter, pos : Vector2):
	letterSound.play()
	
	# Filter out non letters characters
	if letter.to_lower() in "abcdefghijklmnopqrstuvwxyz":
		transit(letter, pos)


func transit(letter, pos : Vector2, push_front := false):
	var transitLetter = TransitLetter.new()
	transitLetter.letter = letter
	transitLetter.start = pos
	
	if push_front:
		in_transit.push_front(transitLetter)
		var offset = joined
		for tl in in_transit:
			offset += tl.letter
			tl.destination = get_next_char_pos(offset)
	else :
		var transiting := []
		for e in in_transit:
			transiting.append(e.letter)
		transitLetter.destination = get_next_char_pos(joined + join_array(transiting) + letter)
		in_transit.append(transitLetter)
	add_child(transitLetter)


func get_next_char_pos(string : String) -> Vector2:
	var w : int = label.rect_size.x
	var string_size = font.get_string_size(string)
	var x : int = int(string_size.x) % w
	var y = floor(string_size.x / w) * string_size.y + string_size.y * 0.5
	return global_position + Vector2(x, y)


func register_letter(letter):
	letter = letter.to_upper()
	var n = collected.size()
	# Check number of consecutive letters
	var n_consecutive = 1
	if n >= 2:
		for i in range(1, n):
			if collected[-i] == collected[-i-1]:
				n_consecutive += 1
			else: break
	
	# Collect consecutive letters bonus
	if n_consecutive >= 3 and letter != collected[-1]:
		emit_signal("add_score", n_consecutive * n_consecutive)
		# Remove letter combo from collected
		var char_pos = get_next_char_pos(joined + letter)
		for _i in range(n_consecutive):
			collected.pop_back()
		wordSound.play()
		joined = join_array(collected)
		transit(letter, char_pos, true)
	else:
		collected.append(letter)
		joined = join_array(collected)

	for bw in bonus_words:
		if joined.ends_with(bw):
			joined = joined.trim_suffix(bw)
			for _i in range(len(bw)):
				collected.pop_back()
			emit_signal("add_score", len(bw) * len(bw))
			wordSound.play()
			break
	label.text = joined.to_upper()
	emit_signal("letter_collected", len(collected))
