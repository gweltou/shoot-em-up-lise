extends AbstractKelenner


var LaserPath = preload("LaserPath.gd")
var LaserReflect = preload("LaserReflect.gd")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func behave():
	if randf() < 0.1:
#		laser_attack_1()
#		laser_reflect_attack()
		angel_of_symmetry_attack()


func laser_attack_1():
	var laser_path = LaserPath.new()
	laser_path.translate(position + Vector2(0, 16))
	owner.add_child(laser_path)
	var player_pos = get_parent().get_node("Player").position
	laser_path.add_point(player_pos)


func laser_reflect_attack():
	var laser = LaserReflect.new()
	laser.collision_exceptions.append(estrade.get_parent())
	shoot(laser, PI*0.5 + randf() - 0.5)


func angel_of_symmetry_attack():
	var laser = LaserReflect.new()
	laser.hitval = -2
	
	var pattern = WavePattern.new(self, laser)
	pattern.number = 4
	pattern.duration = 1
	#pattern.aimed = aimed
	add_child(pattern)
