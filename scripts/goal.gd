extends Area2D

@export var goal_id = 1

func _on_body_entered(body):
	if body is Ball:
		if body.can_score:
			get_parent().goal_scored(goal_id)
