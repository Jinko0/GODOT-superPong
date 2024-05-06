extends RigidBody2D

var level_power = 1
var player = CharacterBody2D

func _ready():
	# Variables permettant de détecter les collisions avec les murs
	contact_monitor = true
	max_contacts_reported = 1

func _process(delta):
	#print("damp " + str(linear_damp))
	print("level " + str(level_power))
	pass

func _on_body_entered(body):
	
	# A chaque rebond contre un mur on réduit la vitesse de la balle ainsi que son level
	if body is StaticBody2D:
		#if level_power > 1:
			#level_power -= 1
		if linear_damp < 1 :
			linear_damp += 0.25
