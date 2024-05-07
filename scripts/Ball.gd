extends RigidBody2D
class_name Ball

var level_power = 1
var player = CharacterBody2D

var push_force = 800.0
var can_score = false

@onready var sprite = $Sprite2D
@onready var bounce_sound = $BounceSound

func _ready():
	# Variables permettant de détecter les collisions avec les murs
	contact_monitor = true
	max_contacts_reported = 1

func _process(delta):
	#print("damp " + str(linear_damp))
	print("level " + str(level_power))
	#print(linear_velocity.length())
	
	###
	###
	### toute cette partie est vraiment pas ouf TODO > corriger plus tard
	if linear_velocity.length() < 100 * level_power && level_power > 1.1:
		level_power -= 0.05
	
	if (level_power >= 1.99):	
		sprite.set_frame(5)
	elif (level_power >= 1.79):
		sprite.set_frame(4)
	elif (level_power >= 1.59):
		sprite.set_frame(3)
	elif (level_power >= 1.39):
		sprite.set_frame(2)
	elif (level_power >= 1.19):
		sprite.set_frame(1)
	elif (level_power >= 1):
		sprite.set_frame(0)
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
