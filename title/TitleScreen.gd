extends Node


onready var Cat = $BackgroundGroup/Cat
onready var BgImage = $BackgroundGroup/BackgroundImage
onready var Paw = $Paw
onready var tweenPages = $TweenPages

onready var main_menu := [$BtnStory, $BtnArcade, $BtnOption, $BtnQuit]
onready var option_menu := [$LblLanguage, $LblVibration]

var flags = [preload("res://title/assets/br.png"),
			 preload("res://title/assets/fr.png")]

onready var current_menu = main_menu

var timer := 0.0
var background_rotation : float
var background_offset : Vector2
var background_orig : Vector2
var background_scale_orig : Vector2
var cat_orig : Vector2
var cat_scale_orig : Vector2

var locked := false
var menu_idx := 0
var eyelid_counter = 0.0
var menu_xpos := 180


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = 0
	get_tree().paused = false
	
	Cat.get_node("Eyelid1").visible = false
	Cat.get_node("Eyelid2").visible = false
	
	var paw_width = Paw.get_sprite_frames().get_frame("default", 0).get_width()
	paw_width *= Paw.scale.x
	Paw.position.x = menu_xpos - paw_width * 0.6
	Paw.position.y = current_menu[menu_idx].rect_position.y
	Paw.position.y += current_menu[menu_idx].rect_size.y * 0.6
	
	for item in current_menu:
		item.rect_position.x = menu_xpos
	
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
	Paw.position.y += current_menu[menu_idx].rect_size.y * 0.7
	$MenuChange.play()


func _process(delta):
	timer += delta
	
	if Input.is_action_just_pressed("ui_up") and not locked:
		var prev = menu_idx
		menu_idx = (menu_idx + len(current_menu) - 1) % len(current_menu)
		var tween = $TweenItem
		tween.interpolate_property(current_menu[prev], "rect_scale",
										Vector2(1.2, 1.2), Vector2(1, 1), 0.1)
		tween.interpolate_property(current_menu[menu_idx], "rect_scale",
										Vector2(1, 1), Vector2(1.2, 1.2), 0.1)
		tween.start()
		move_paw()
	elif Input.is_action_just_pressed("ui_down") and not locked:
		var prev = menu_idx
		menu_idx = (menu_idx + 1) % len(current_menu)
		var tween = $TweenItem
		tween.interpolate_property(current_menu[prev], "rect_scale",
										Vector2(1.2, 1.2), Vector2(1, 1), 0.1)
		tween.interpolate_property(current_menu[menu_idx], "rect_scale",
										Vector2(1, 1), Vector2(1.2, 1.2), 0.1)
		tween.start()
		move_paw()
	
	elif timer > 0.1 and (Input.is_action_just_pressed("ui_select") or Input.is_action_just_pressed("ui_accept")):
		Paw.set_frame(0)
		Paw.play("default") # Paw animation
		
		GameVariables.current_score = 0
		
		if current_menu == main_menu:
			if menu_idx == 0 or menu_idx == 1: # Start game
				if locked == true:	# Second press to skip intro zoom
					_on_StartGameSFX_finished()
				$StartGameSFX.play()
				if menu_idx == 1:
					GameVariables.arcade_mode = true
				else:
					GameVariables.arcade_mode = false
				locked = true
				var tweenStart = $TweenStart
				tweenStart.interpolate_property($BackgroundGroup, "rect_scale",
											Vector2(1, 1), Vector2(2, 2), 4)
				tweenStart.interpolate_method($BackgroundGroup, "set_rotation",
											0, 100, 4, Tween.TRANS_LINEAR)
				tweenStart.start()
			elif menu_idx == 2:
				_to_option_menu()
				
		elif current_menu == option_menu:
			$MenuChange.play()
			if menu_idx == 0: # Language
				GameVariables.option_lang = (GameVariables.option_lang + 1) % len(GameVariables.lang)
				$LblLanguage/LabelLangValue.text = GameVariables.lang[GameVariables.option_lang]
				$LblLanguage/Flag.set_texture(flags[GameVariables.option_lang])
			elif menu_idx == 1:	# Vibration
				GameVariables.option_vibration = not GameVariables.option_vibration
				if GameVariables.option_vibration == true:
					$LblVibration/LblVibrationValue.text = "on"
				else:
					$LblVibration/LblVibrationValue.text = "off"
	
	elif Input.is_action_just_pressed("ui_cancel"):
		if current_menu == option_menu:
			_to_main_menu()
	
	elif Input.is_action_just_pressed("ui_right"):
		if current_menu == main_menu and menu_idx == 2:
			_to_option_menu()
	
	elif Input.is_action_just_pressed("ui_left") and current_menu == option_menu:
		_to_main_menu()
	
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
	##Cat.rect_scale = cat_scale_orig +  Vector2(s, s)
	
	# Screen movement
	background_offset = Vector2(1.4 * sin(timer * 1.2), 1.5 * cos(timer * 2.0))
	$BackgroundGroup.rect_position = background_offset
	Cat.rect_position = cat_orig + 2 * background_offset
	background_rotation = 0.003 * sin(timer * 1.2)
	$BackgroundGroup.set_rotation(background_rotation)
	
	# Title animation
	s = 1 + 0.01 * sin(timer * 7)
	$Title.rect_scale = Vector2(s, s)


func _to_main_menu():
	var tween = $TweenItem
	tween.interpolate_property(current_menu[menu_idx], "rect_scale",
								Vector2(1.2, 1.2), Vector2(1, 1), 0.1)
	tween.interpolate_property(main_menu[0], "rect_scale",
								Vector2(1, 1), Vector2(1.2, 1.2), 0.1)
	tween.start()
	
	var screen_width = OS.get_screen_size().y
	var delay = 0
	for menuItem in main_menu:
		tweenPages.interpolate_property(menuItem, "rect_position:x",
										-screen_width, menu_xpos, 0.1,
										0, 2, delay)
		delay += 0.05
	delay = 0
	for menuItem in option_menu:
		tweenPages.interpolate_property(menuItem, "rect_position:x",
										menu_xpos, screen_width*1.5, 0.1,
										0, 2, delay)
		delay += 0.05
	tweenPages.start()
	locked = true
	$Paw.visible = false
	current_menu = main_menu
	menu_idx = 0
	move_paw()


func _to_option_menu():
	var tween = $TweenItem
	tween.interpolate_property(current_menu[menu_idx], "rect_scale",
								Vector2(1.2, 1.2), Vector2(1, 1), 0.1)
	tween.interpolate_property(option_menu[0], "rect_scale",
								Vector2(1, 1), Vector2(1.2, 1.2), 0.1)
	tween.start()
	
	var screen_width = OS.get_screen_size().y
	var delay = 0
	for menuItem in main_menu:
		tweenPages.interpolate_property(menuItem, "rect_position:x",
										menu_xpos, -screen_width, 0.1,
										0, 2, delay)
		delay += 0.05
	delay = 0
	for menuItem in option_menu:
		tweenPages.interpolate_property(menuItem, "rect_position:x",
										screen_width*1.3, menu_xpos, 0.1,
										0, 2, delay)
		delay += 0.05
	tweenPages.start()
	locked = true
	$Paw.visible = false
	current_menu = option_menu
	menu_idx = 0
	move_paw()


func _on_StartGameSFX_finished():
	locked = false
	if menu_idx == 0:
		get_tree().change_scene("res://vn/a01s01.tscn")
	elif menu_idx == 1:
		get_tree().change_scene("res://seu/LevelYezh.tscn")
	


func _on_Tween_tween_all_completed():
	locked = false
	$Paw.visible = true
