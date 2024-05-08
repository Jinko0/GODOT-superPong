extends Area2D
class_name Player

@export var push_force = 800.0

@onready var body_block_cooldown = $"../Body_block_cooldown"

func _ready():
	get_parent().shoot.connect(shoot)


func shoot():
	get_parent().curent_state = get_parent().States.SHOOT
	for body in get_overlapping_bodies():
		if body is RigidBody2D:
			body.shoot_sound.play()
			apply_impulse(body)

func apply_impulse(body):
	# on donne l'inertie à la balle et on reset sa velocité
	body.set_linear_damp(0)
	body.set_linear_velocity(Vector2.ZERO)

	# cooldown pour empecher le corps du joueur de ralentir instantanément la balle apès un tir
	body_block_cooldown.start()
	# On donne l'impulsion à la balle 
	var direction_to_shoot = global_position.direction_to(body.global_position)
	body.apply_central_impulse(direction_to_shoot * push_force * body.level_power)
	
	# On augmente la puissance de la balle à chaque coup
	if body.level_power < 2:
		body.level_power += 0.2
	
	body.camera.apply_shake()

