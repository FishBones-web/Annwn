class_name PlayerState
extends LimboState

@export var animation_name : String

var player : CharacterBody2D
var player_stats : PlayerStats

#when state is entered
func _enter():
	player = agent as CharacterBody2D
	agent.sprite.play(animation_name)
	player_stats = player.player_stats
	
func move() -> Vector2:
	
	var direction : Vector2 = blackboard.get_var(BBNames.direction_var)
	
	if not is_zero_approx(direction.x):
		player.velocity.x = direction.x * player_stats.run_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player_stats.run_speed)

	player.move_and_slide()
	return player.velocity
	
