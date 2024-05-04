extends Area2D
class_name Player

@export var push_force = 800.0
@export var shot_available = false

@onready var animation_player = $AnimationPlayer

func _ready():
	get_parent().shoot.connect(shoot)
	# FIX TEMPORAIRE
	# la main est tourné vers le haut au lancement de la scene pour je ne sais quel raison, je la re set à droite. 
	rotation = 0

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body is RigidBody2D:
			if shot_available:
				apply_impulse(body)

func shoot():
	# Au début de l'animation on set à true shot_available pour déclencher un tir si la hitbox detecte la balle pendant l'anim
	# shot_available est de nouveau set à false à la fin de l'anim
	animation_player.play("shoot")

func apply_impulse(body):
	# on donne l'inertie à la balle et on reset sa velocité
	body.set_linear_damp(0)
	body.set_linear_velocity(Vector2.ZERO)
	
	# on définit l'angle du tir en prenant la direction entre la postion de la main et celle de la balle
	var shot_direction = global_position.direction_to(body.global_position)
	
	# On donne l'impulsion à la base 
	body.apply_central_impulse(shot_direction * push_force * body.level_power)
	
	# On augmente la puissance de la balle à chaque coup
	if body.level_power < 2:
		body.level_power += 0.2
	
	# On empêche de trigger la fonction plusieurs fois avecun suel coup
	shot_available = false
