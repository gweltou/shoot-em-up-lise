extends RigidBody2D
class_name Player

var move_speed = 12000
var moving = false
var counter = 0

onready var invicibility = $InvicibilityTimer
onready var sprite = $AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	counter += delta
	
	if not invicibility.is_stopped() and fmod(counter, 0.2) < 0.1:
		sprite.material.set_shader_param("activated", true)
	else:
		sprite.material.set_shader_param("activated", false)


func _integrate_forces(state):
	var vel = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	set_applied_force(vel * move_speed)
	
	var l = vel.length_squared()
	if not moving and l > 0:
		$AnimatedSprite.play("default")
		#set_angular_velocity(0)
		#rotation_degrees = 0
		state.transform = Transform2D(0, position)
		moving = true
	elif moving and l == 0:
		$AnimatedSprite.stop()
		$AnimatedSprite.set_frame(0)
		moving = false


func hit(bullet : Bullet):
	if bullet.hitval < 0 and invicibility.is_stopped():
		invicibility.start()
		$PlayerHit.play()
		var dir = position - bullet.position
		apply_central_impulse(dir * 80)
		apply_torque_impulse(1000 * (randf() - 0.5))
		if GameVariables.option_vibration == true:
			Input.start_joy_vibration(0, 0, 1, 0.1)
	else:
		if $PlayerLetter.is_playing():
			$PlayerLetter2.play()
		else:
			$PlayerLetter.play()
