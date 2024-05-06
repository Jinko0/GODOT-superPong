extends CharacterBody2D


@export var speed = 600  # speed in pixels/sec
@export var acceleration = 0.1
@export var friction = 0.08
@export var push_force = 50.0

var last_direction = Vector2.ZERO

@onready var catch_position = $Catch_position

signal shoot

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	# On applique l'acceleration et la fiction sur le déplacement
	if direction.length() > 0:
		velocity = velocity.lerp(direction.normalized() * speed, acceleration)
	else:
		velocity = velocity.lerp(direction.normalized() * speed, friction)
		
	# On tourne le joueur dans la dernière direction pressée
	if direction != Vector2.ZERO:
		last_direction = direction.normalized()
		rotation = last_direction.angle()
		
	if Input.is_action_just_pressed("shoot"):
		shoot.emit()

	move_and_slide()

	# on récupère les body avec lesquels le joueur collisione afin que la joueur pousse la balle
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
			
			# TODO ajouter les effet sur le joueur lors de la collision en fonction du niveau de puissance de la balle
			if c.get_collider().level_power > 2:
				# stun le joueur si balle trop de puissance
				pass
