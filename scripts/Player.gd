extends CharacterBody2D


@export var speed = 600  # speed in pixels/sec
@export var acceleration = 0.1
@export var friction = 0.08
@export var push_force = 50.0
@export var player_id = 1

var impact_velocity = 0
var impact_direction : Vector2
var stun = false
var score = 0
var can_move = false


@onready var body_block_cooldown = $Body_block_cooldown
@onready var stun_cooldown = $Stun_cooldown
@onready var animated_sprite = $AnimatedSprite2D

@onready var stun_sound = $StunSound


signal shoot

func _physics_process(delta):
	if can_move:
		var direction = Input.get_vector("left_%s" % [player_id] , "right_%s" % [player_id], "up_%s" % [player_id], "down_%s" % [player_id])
		# On applique l'acceleration et la fiction sur le déplacement
		if direction.length() > 0:
			velocity = velocity.lerp(direction.normalized() * speed, acceleration)
		else:
			velocity = velocity.lerp(direction.normalized() * speed, friction)
			
				
		if Input.is_action_just_pressed("shoot_%s" % [player_id]):
			shoot.emit()

		if stun:
			velocity = impact_velocity * impact_direction
			if impact_velocity > 0:
				impact_velocity -= 10

		move_and_slide()

	# on récupère les body avec lesquels le joueur collisione afin que la joueur pousse la balle
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			print(body_block_cooldown.time_left)
			if !(body_block_cooldown.time_left > 0):
				c.get_collider().set_linear_damp(3)
				
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
			
			# TODO ajouter les effet sur le joueur lors de la collision en fonction du niveau de puissance de la balle
			if c.get_collider().level_power > 2 && !(body_block_cooldown.time_left > 0):
				on_stun(c.get_collider())
				# stun le joueur si balle trop de puissance
				pass

func on_stun(body):
	stun = true
	impact_velocity = 400
	impact_direction = body.global_position.direction_to(global_position)
	stun_cooldown.start()
	stun_sound.play()

func _on_stun_cooldown_timeout():
	stun = false
