extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Paw = $Paw
onready var btnStoryPos = $BtnStory.rect_position.y + $BtnStory.rect_size.y * 0.5
onready var btnArcadePos = $BtnArcade.rect_position.y + $BtnArcade.rect_size.y * 0.5
onready var btnOptionPos = $BtnOption.rect_position.y + $BtnOption.rect_size.y * 0.5
onready var btnQuitPos = $BtnQuit.rect_position.y + $BtnQuit.rect_size.y * 0.5
var pawHeight : float

var menu_idx := 0
onready var menu_pos := [btnStoryPos, btnArcadePos, btnOptionPos, btnQuitPos]
var eyelid_counter = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Cat/Eyelid1.visible = false
	$Cat/Eyelid2.visible = false
	
	pawHeight = Paw.get_sprite_frames().get_frame("default", 0).get_size().y
	pawHeight *= Paw.scale.y
	Paw.position.y = menu_pos[menu_idx]


func move_paw():
	Paw.position.y = menu_pos[menu_idx]
	$MenuChange.play()
	

func _unhandled_input(event):
	if event.is_action_pressed("ui_up"):
		menu_idx = (menu_idx - 1) % len(menu_pos)
		move_paw()
	elif event.is_action_pressed("ui_down"):
		menu_idx = (menu_idx + 1) % len(menu_pos)
		move_paw()
	elif event.is_action_pressed("ui_select") or event.is_action_pressed("ui_accept"):
		Paw.play("default")
		$MenuAccept.play()
	

func _process(delta):
	if eyelid_counter <= 0.0:
		$Cat/Eyelid1.visible = false
		$Cat/Eyelid2.visible = false
		if randf() < 0.005:
			$Cat/Eyelid1.visible = true
			$Cat/Eyelid2.visible = true
			eyelid_counter = 0.2
	else:
		eyelid_counter -= delta
		

func _on_Paw_animation_finished():
	Paw.stop()
