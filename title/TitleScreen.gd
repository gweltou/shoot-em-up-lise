extends Node


onready var Cat = $BackgroundGroup/Cat
onready var BgImage = $BackgroundGroup/BackgroundImage
onready var Paw = $Paw
onready var tween = $Tween

onready var main_menu := [$BtnStory, $BtnArcade, $BtnOption, $BtnQuit]
onready var option_menu := [$LblLanguage, $LblVibration]

onready var current_menu = main_menu

var timer := 0.0
var timer2 := 0.0
var background_rotation : float
var background_offset : Vector2
var background_orig : Vector2
var background_scale_orig : Vector2
var cat_orig : Vector2
var cat_scale_orig : Vector2

var locked := false
var menu_idx := 0
var eyelid_counter = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	
	Cat.get_node("Eyelid1").visible = false
	Cat.get_node("Eyelid2").visible = false
	
	Paw.position.y = current_menu[menu_idx].rect_position.y
	Paw.position.y += current_menu[menu_idx].rect_size.y * 0.5
	
	background_orig = Vector2(BgImage.position.x, BgImage.position.y)
	background_scale_orig = Vector2(BgImage.scale.x, BgImage.scale.y)
	cat_orig = Vector2(Cat.rect_position.x, Cat.rect_position.y)
	cat_scale_orig = Vector2(Cat.rect_scale.x, Cat.rect_scale.y)
	
	if GameVariables.option_vibration == true:
		$LblVibration/LblVibrationValue.text = "on"
	else:
		$LblVibration/LblVibrationValue.text = "off"
	
	$LblLanguage/LabelLangValue.text = GameVariables.lang[GameVariables.option_lang]


func move_paw():
	Paw.position.y = current_menu[menu_idx].rect_position.y
	Paw.position.y += current_menu[menu_idx].rect_size.y * 0.5
	$MenuChange.play()


func _process(delta):
	timer += delta
	
	if Input.is_action_just_pressed("ui_up") and not locked:
		menu_idx = (menu_idx - 1) % len(current_menu)
		move_paw()
	elif Input.is_action_just_pressed("ui_down") and not locked:
		menu_idx = (menu_idx + 1) % len(current_menu)
		move_paw()
	
	elif Input.is_action_just_pressed("ui_select") or Input.is_action_just_pressed("ui_accept"):
		Paw.play("default") # Paw animation
		
		if current_menu == main_menu:
			if menu_idx == 0 or menu_idx == 1: # Start game
				if locked == true:	# Second press to skip intro zoom
					_on_StartGameSFX_finished()
				$StartGameSFX.play()
				locked = true
			elif menu_idx == 2:	# Option menu
				var screen_width = OS.get_screen_size().y
				var delay = 0
				for menuItem in main_menu:
					tween.interpolate_property(menuItem, "rect_position:x",
											screen_width*0.3, -screen_width, 0.4,
											0, 2, delay)
					delay += 0.1
				delay = 0
				for menuItem in option_menu:
					tween.interpolate_property(menuItem, "rect_position:x",
											screen_width*1.3, screen_width*0.3, 0.4,
											0, 2, delay)
					delay += 0.1
				tween.start()
				locked = true
				$Paw.visible = false
				current_menu = option_menu
				menu_idx = 0
				move_paw()
				
		elif current_menu == option_menu:
			$MenuChange.play()
			if menu_idx == 0: # Language
				GameVariables.option_lang = (GameVariables.option_lang + 1) % len(GameVariables.lang)
				$LblLanguage/LabelLangValue.text = GameVariables.lang[GameVariables.option_lang]
			elif menu_idx == 1:	# Vibration
				GameVariables.option_vibration = not GameVariables.option_vibration
				if GameVariables.option_vibration == true:
					$LblVibration/LblVibrationValue.text = "on"
				else:
					$LblVibration/LblVibrationValue.text = "off"
	
	elif Input.is_action_just_pressed("ui_cancel"):
		if current_menu == option_menu:
			var screen_width = OS.get_screen_size().y
			var delay = 0
			for menuItem in main_menu:
				tween.interpolate_property(menuItem, "rect_position:x",
										-screen_width, screen_width*0.3, 0.4,
										0, 2, delay)
				delay += 0.1
			delay = 0
			for menuItem in option_menu:
				tween.interpolate_property(menuItem, "rect_position:x",
										screen_width*0.3, screen_width*1.3, 0.4,
										0, 2, delay)
				delay += 0.1
			tween.start()
			locked = true
			$Paw.visible = false
			current_menu = main_menu
			menu_idx = 0
			move_paw()
	
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
	if locked:
		timer2 += delta
		Cat.rect_scale += Vector2(0.1 * timer2, 0.1 * timer2)
	
	# Screen movement
	background_offset = Vector2(1.4 * sin(timer * 1.2), 1.5 * cos(timer * 2.0))
	$BackgroundGroup.position = background_offset
	Cat.rect_position = cat_orig + 2 * background_offset
	background_rotation = 0.003 * sin(timer * 1.2)
	$BackgroundGroup.rotation = background_rotation
	if locked:
		$BackgroundGroup.rotation += 4 * timer2 * background_rotation
	
	# Title animation
	s = 1 + 0.01 * sin(timer * 7)
	$Title.rect_scale = Vector2(s, s)


func _on_StartGameSFX_finished():
	locked = false
	if menu_idx == 0:
		get_tree().change_scene("res://vn/a01s01.tscn")
	elif menu_idx == 1:
		get_tree().change_scene("res://seu/Level.tscn")
	


func _on_Tween_tween_all_completed():
	locked = false
	$Paw.visible = true
