extends RigidBody2D

var items_folder = "res://seu/classroom/"
var items = ["levr 1.png", "levr 2.png", "paperiou.png"]
var items_upper = ["pod.png", "telephone.png", "trousenn.png"]
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var table_size = $Sprite.texture.get_size() * $Sprite.scale
	
	var item_sprite = Sprite.new()
	var rnd_i = randi() % len(items)
	item_sprite.texture = load(items_folder.plus_file(items[rnd_i]))
	item_sprite.scale = Vector2(1.5, 1.5) 
	var item_size = item_sprite.texture.get_size() * item_sprite.scale
	var max_offset = (table_size / 2) - (item_size / 2)
	var rnd_x = (randf()-0.5) * max_offset.x
	var rnd_y = (randf()-0.5) * max_offset.y
	item_sprite.translate(Vector2(rnd_x, rnd_y))
	item_sprite.rotate((randf()-0.5) * 1)
	add_child(item_sprite)
	
	item_sprite = Sprite.new()
	rnd_i = randi() % len(items_upper)
	item_sprite.texture = load(items_folder.plus_file(items_upper[rnd_i]))
	item_sprite.scale = Vector2(1.8, 1.8) 
	item_size = item_sprite.texture.get_size() * item_sprite.scale
	max_offset = (table_size / 2) - (item_size / 2)
	rnd_x = (randf()-0.5) * max_offset.x
	rnd_y = (-randf()) * max_offset.y
	item_sprite.translate(Vector2(rnd_x, rnd_y))
	item_sprite.rotate((randf()-0.5) * 1)
	add_child(item_sprite)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
