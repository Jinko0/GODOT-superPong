extends Area2D
class_name Player

@export var push_force = 800.0

func _ready():
	get_parent().shoot.connect(shoot)


func shoot():
		for body in get_overlapping_bodies():
			if body is RigidBody2D:
				apply_impulse(body)

func apply_impulse(body):
	# on donne l'inertie à la balle et on reset sa velocité
	body.set_linear_damp(0)
	body.set_linear_velocity(Vector2.ZERO)

	# On donne l'impulsion à la balle 
	body.apply_central_impulse(get_parent().last_direction * push_force * body.level_power)
	
	# On augmente la puissance de la balle à chaque coup
	if body.level_power < 2:
		body.level_power += 0.2

