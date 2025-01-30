extends PlayerState
##run state

func _update(_delta: float) -> void:
	var velocity : Vector2 = move()
	
	if Vector2.ZERO.is_equal_approx(velocity):
		dispatch("stopped",velocity)
	
	##so first checks if blackboard has registered the jump input being made, also makes sure the plaer is on the ground.
	## then checks blackboard for the current jump counter, makes sure theres no concessive jumps
	if blackboard.get_var(BBNames.jump_var) && player.is_on_floor() && blackboard.get_var(BBNames.jumps_made_var) == 0:
		
		jump()
		
func jump():
	player.velocity.y = -player_stats.jump_velocity
	var current_jumps : int = blackboard.get_var(BBNames.jumps_made_var)
	blackboard.set_var(BBNames.jumps_made_var, current_jumps + 1)
