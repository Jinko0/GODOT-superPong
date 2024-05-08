extends RigidBody2D
class_name Ball

var level_power = 1
var player = CharacterBody2D

var push_force = 800.0
var can_score = false

@onready var sprite = $Sprite2D
@onready var bounce_sound = $BounceSound
@onready var shoot_sound = $ShootSound
@onready var camera = $Camera2D
@onready var ball_power = $BallPower
@onready var ball_light = $BallLight



func _ready():
	# Variables permettant de détecter les collisions avec les murs
	contact_monitor = true
	max_contacts_reported = 1

func _process(delta):
	ball_power.global_position = get_parent().ball_power_position.global_position
	ball_power.global_rotation = 0.0
	#print("damp " + str(linear_damp))
	#print("level " + str(level_power))
	#print(linear_velocity.length())
	###
	###
	### toute cette partie est vraiment pas ouf TODO > corriger plus tard
	if linear_velocity.length() < 500 * level_power && level_power > 1.1:
		level_power -= 0.05
	
	if (level_power >= 1.99):
		ball_light.color = Color("f11313")
		set_power_effect(5, 1.5, 10, 20.0)
	elif (level_power >= 1.79):
		ball_light.color = Color("793cf0")
		set_power_effect(4, 1.4, 8, 18.0)
	elif (level_power >= 1.59):
		ball_light.color = Color("af8af5")
		set_power_effect(3, 1.3, 6, 15.0)
	elif (level_power >= 1.39):
		ball_light.color = Color("33a1f6")
		set_power_effect(2, 1.2, 4, 12.0)
	elif (level_power >= 1.19):
		ball_light.color = Color("80c4f8")
		set_power_effect(1, 1.1, 2, 9.0)
	elif (level_power >= 1):
		ball_light.color = Color("c4e2f9")
		set_power_effect(0, 1, 0, 5.0)
	###
	###
	###

func _on_body_entered(body):
	
	# A chaque rebond contre un mur on réduit la vitesse de la balle ainsi que son level
	if body is StaticBody2D:
		bounce_sound.play()
		#if level_power > 1:
			#level_power -= 0.1
		if linear_damp < 1 :
			linear_damp += 0.25

func reset_position(position):
	linear_velocity = Vector2.ZERO
	set_global_position(position)

func set_power_effect(frame, sound_pitch, sound_volume, camera_shake_strength):
		sprite.set_frame(frame)
		shoot_sound.pitch_scale = sound_pitch
		shoot_sound.volume_db = sound_volume
		camera.random_strength = camera_shake_strength
		ball_power.set_frame(frame)
