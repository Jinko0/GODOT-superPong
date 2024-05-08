extends CharacterBody2D


@export var speed = 800  # speed in pixels/sec
@export var acceleration = 0.1
@export var friction = 0.08
@export var push_force = 50.0
@export var player_id = 1

var impact_velocity = 0
var impact_direction : Vector2
var score = 0
var can_move = false

enum States {IDLE, RUN, SHOOT, STUN}
var curent_state : int = States.IDLE

@onready var body_block_cooldown = $Body_block_cooldown
@onready var stun_cooldown = $Stun_cooldown
@onready var animated_sprite = $AnimatedSprite2D
@onready var stun_animation = $StunAnimation

@onready var stun_sound = $StunSound
@onready var shoot_sound = $ShootSound
@onready var shoot_cooldown = $shoot_cooldown


signal shoot

func _physics_process(delta):
	if can_move:
		var direction = Input.get_vector("left_%s" % [player_id] , "right_%s" % [player_id], "up_%s" % [player_id], "down_%s" % [player_id])
		# On applique l'acceleration et la fiction sur le déplacement
		if direction.length() > 0:
			if curent_state != States.SHOOT : curent_state = States.RUN
			velocity = velocity.lerp(direction.normalized() * speed, acceleration)
		else:
			if curent_state != States.SHOOT : curent_state = States.IDLE
			velocity = velocity.lerp(direction.normalized() * speed, friction)

		if direction.x > 0:
			animated_sprite.flip_h = true
		elif direction.x < 0:
			animated_sprite.flip_h = false

		if Input.is_action_just_pressed("shoot_%s" % [player_id]) && shoot_cooldown.time_left <= 0:
			shoot_cooldown.start()
			shoot_sound.play()
			shoot.emit()

	if curent_state == States.STUN:
		velocity = impact_velocity * impact_direction
		if impact_velocity > 0:
			impact_velocity -= 10

	move_and_slide()

func _process(delta):
	match curent_state:
		States.IDLE:
			animated_sprite.set_animation("idle%s" % [player_id])
		States.RUN:
			animated_sprite.set_animation("run%s" % [player_id])
		States.SHOOT:
			animated_sprite.set_animation("shoot")
		States.STUN:
			animated_sprite.set_animation("idle%s" % [player_id])
	
	# on récupère les body avec lesquels le joueur collisione afin que la joueur pousse la balle
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			print(body_block_cooldown.time_left)
			if !(body_block_cooldown.time_left > 0):
				c.get_collider().set_linear_damp(3)
				
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
			
			# TODO ajouter les effet sur le joueur lors de la collision en fonction du niveau de puissance de la balle
			if c.get_collider().level_power >= 2 && !(body_block_cooldown.time_left > 0):
				on_stun(c.get_collider())
				# stun le joueur si balle trop de puissance
				pass

func on_stun(body):
	stun_animation.visible = true
	can_move = false
	curent_state = States.STUN
	impact_velocity = 400
	impact_direction = body.global_position.direction_to(global_position)
	stun_cooldown.start()
	stun_sound.play()

func _on_stun_cooldown_timeout():
	stun_animation.visible = false
	can_move = true
	curent_state = States.IDLE

func _on_animated_sprite_2d_animation_looped():
	if animated_sprite.animation == "shoot":
		curent_state = States.IDLE
