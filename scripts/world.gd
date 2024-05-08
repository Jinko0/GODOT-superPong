extends Node2D

@onready var player_1 = $Player1
@onready var player_2 = $Player2
@onready var player_1_position = $Player1Position
@onready var player_2_position = $Player2Position
@onready var player_1_score_label = $Player1Score
@onready var player_2_score_label = $Player2Score
@onready var ball_position = $BallPosition
@onready var ball_power_position = $BallPowerPosition

@onready var score_goal_timer = $ScoreGoalTimer
@onready var match_timer = $MatchTimer
@onready var timer_label = $TimerLabel
@onready var kickoff_timer = $KickoffTimer
@onready var match_over = $MatchOver

@onready var goal_sound = $GoalSound
@onready var whistle_sound = $WhistleSound
@onready var match_timer_sound = $MatchTimerSound
@onready var end_match_whistle_sound = $EndMatchWhistleSound
@onready var music = $Music



var ball
var ball_scene = preload("res://scenes/ball.tscn")
var players_can_score = true
var match_is_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_players_positions()
	set_ball_position()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer_label.set_text("%d:%02d" % [floor(match_timer.time_left / 60), int(match_timer.time_left) % 60])
	
	if match_timer.time_left < 10 && !match_timer_sound.playing && !match_timer.is_stopped():
		match_timer_sound.play()
	
	if match_is_over && Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
		

func set_players_positions():
	player_1.animated_sprite.flip_h = true
	player_2.animated_sprite.flip_h = false
	player_1.set_global_position(player_1_position.global_position)
	player_2.set_global_position(player_2_position.global_position)

func set_ball_position():
	ball = ball_scene.instantiate()
	add_child(ball)
	ball.set_global_position(ball_position.global_position)
	kickoff_timer.start()

func kick_off():
	player_1.can_move = true
	player_2.can_move = true
	ball.can_score = true
	whistle_sound.play()

func goal_scored(goal_id):
	goal_sound.play()
	player_1.set_velocity(Vector2.ZERO)
	player_1.can_move = false
	player_2.set_velocity(Vector2.ZERO)
	player_2.can_move = false
	ball.can_score = false
	
	# si c'est le goal d'id 1 qui envoie le signal alors c'est le joueur 2 qui score et inversement
	match goal_id:
		1:
			player_score_goal(player_2, player_2_score_label)
		2:
			player_score_goal(player_1, player_1_score_label)

	score_goal_timer.start()

func player_score_goal(player, player_score_label):
	player_1.curent_state = player_1.States.IDLE
	player_2.curent_state = player_2.States.IDLE
	player.score += 1
	player_score_label.set_text(str(player.score))

func _on_score_goal_timer_timeout():
	if players_can_score:
		ball.queue_free()
		set_players_positions()
		set_ball_position()


func _on_match_timer_timeout():
	players_can_score = false
	player_1.set_velocity(Vector2.ZERO)
	player_1.can_move = false
	player_2.set_velocity(Vector2.ZERO)
	player_2.can_move = false
	player_1.curent_state = player_1.States.IDLE
	player_2.curent_state = player_2.States.IDLE
	ball.can_score = false
	end_match_whistle_sound.play()
	match_is_over = true
	match_over.visible = true
	pass # Replace with function body.


func _on_kickoff_timer_timeout():
	if match_timer.is_stopped():
		match_timer.start()
	kick_off()


func _on_music_finished():
	music.play()
	pass # Replace with function body.
