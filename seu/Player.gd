extends KinematicBody2D
class_name Player


const MOVE_SPEED = 300

const bonus_words = ["ab"]

var swag = 0
var collected_letters = ""
#var last_letter = ''



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _draw():
	var r = $Area2D/CollisionShape2D.shape.radius
	draw_circle(Vector2(0, 0), r, Color(0, 0, 1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(_delta):
	var vel = Vector2()
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
	if Input.is_action_pressed("move_down"):
		vel.y += 1
	if Input.is_action_pressed("move_left"):
		vel.x -= 1
	if Input.is_action_pressed("move_right"):
		vel.x += 1
	
	move_and_slide(vel.normalized() * MOVE_SPEED)


func _on_Area2D_area_entered(area):
	if area.get_owner() is Bullet:
		var bullet = area.get_owner()
		swag += bullet.hitval
		if bullet.letter != '':
			$LetterSoundPlayer.play()
			var n = collected_letters.length()
			# Check number of consecutive letters
			var n_consecutive = 0
			if n >= 2:
				for i in range(1, n):
					if collected_letters[-i] == collected_letters[-i-1]:
						n_consecutive += 1
					else: break
			if n_consecutive >= 2 and bullet.letter != collected_letters[-1]:
				# Collect consecutive letters bonus
				swag += (n_consecutive+1) * (n_consecutive+1)
				collected_letters = collected_letters.substr(0, n-n_consecutive-1)
				$WordSoundPlayer.play()
			collected_letters += bullet.letter
			for bw in bonus_words:
				if collected_letters.ends_with(bw):
					collected_letters = collected_letters.trim_suffix(bw)
					swag += len(bw) * len(bw)
					$WordSoundPlayer.play()
					break
			get_parent().get_node("LabelLetters").text = collected_letters
