extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Cat = $BackgroundGroup/Cat
onready var BgImage = $BackgroundGroup/Img7144
onready var Paw = $Paw
onready var btnStoryPos = $BtnStory.rect_position.y + $BtnStory.rect_size.y * 0.5
onready var btnArcadePos = $BtnArcade.rect_position.y + $BtnArcade.rect_size.y * 0.5
onready var btnOptionPos = $BtnOption.rect_position.y + $BtnOption.rect_size.y * 0.5
onready var btnQuitPos = $BtnQuit.rect_position.y + $BtnQuit.rect_size.y * 0.5

var timer := 0.0
var timer2 := 0.0
var pawHeight : float
var background_rotation : float
var background_offset : Vector2
var background_orig : Vector2
var background_scale_orig : Vector2
var cat_orig : Vector2
var cat_scale_orig : Vector2

var freezed := false
var menu_idx := 0
onready var menu_pos := [btnStoryPos, btnArcadePos, btnOptionPos, btnQuitPos]
var eyelid_counter = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	Cat.get_node("Eyelid1").visible = false
	Cat.get_node("Eyelid2").visible = false
	
	pawHeight = Paw.get_sprite_frames().get_frame("default", 0).get_size().y
	pawHeight *= Paw.scale.y
	Paw.position.y = menu_pos[menu_idx]
	
	background_orig = Vector2(BgImage.position.x, BgImage.position.y)
	background_scale_orig = Vector2(BgImage.scale.x, BgImage.scale.y)
	cat_orig = Vector2(Cat.rect_position.x, Cat.rect_position.y)
	cat_scale_orig = Vector2(Cat.rect_scale.x, Cat.rect_scale.y)


func move_paw():
	Paw.position.y = menu_pos[menu_idx]
	$MenuChange.play()


func _unhandled_input(event):
	if event.is_action_pressed("ui_up") and not freezed:
		menu_idx = (menu_idx - 1) % len(menu_pos)
		move_paw()
	elif event.is_action_pressed("ui_down") and not freezed:
		menu_idx = (menu_idx + 1) % len(menu_pos)
		move_paw()
	elif event.is_action_pressed("ui_select") or event.is_action_pressed("ui_accept"):
		Paw.play("default")
		if menu_idx == 0 or menu_idx == 1:
			$MenuAccept.play()
			freezed = true
	

func _process(delta):
	timer += delta
	
	if eyelid_counter <= 0.0:
		Cat.get_node("Eyelid1").visible = false
		Cat.get_node("Eyelid2").visible = false
		if randf() < 0.005:
			Cat.get_node("Eyelid1").visible = true
			Cat.get_node("Eyelid2").visible = true
			eyelid_counter = 0.2
	else:
		eyelid_counter -= delta
	
	var s = 0.01 * sin(timer * 1.6)
	BgImage.scale = background_scale_orig + Vector2(s, s)
	Cat.rect_scale = cat_scale_orig +  Vector2(s, s)
	if freezed:
		timer2 += delta
		Cat.rect_scale += Vector2(0.1 * timer2, 0.1 * timer2)
	
	# Screen shake
	background_offset = Vector2(1.4 * sin(timer * 1.2), 1.5 * cos(timer * 2.0))
	$BackgroundGroup.position = background_offset
	Cat.rect_position = cat_orig + 2 * background_offset
	background_rotation = 0.003 * sin(timer * 1.2)
	$BackgroundGroup.rotation = background_rotation
	if freezed:
		$BackgroundGroup.rotation += 4 * timer2 * background_rotation
	
	# Title animation
	s = 1 + 0.01 * sin(timer * 7)
	$Title.rect_scale = Vector2(s, s)
	
	
		

func _on_Paw_animation_finished():
	Paw.stop()


func _on_MenuAccept_finished():
	freezed = false
	if menu_idx == 0:
		get_tree().change_scene("res://vn/a01s01.tscn")
	elif menu_idx == 1:
		get_tree().change_scene("res://seu/Level.tscn")
	
