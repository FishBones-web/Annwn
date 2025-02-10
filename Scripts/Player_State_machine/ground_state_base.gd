extends PlayerState
class_name GroundStateBASE


@export var idle_anim : String = "idle"
@export var move_anim : String = "run"
@export var jump_anim : String = "jump"

@export var can_move : bool = true
@export var can_jump : bool = true

@export var movement_speed_var = "run_speed"

#lock to prevent switching to airstate before characterbody has a proper chance to detect collision.
var on_first_frame = true

func _update(_p_delta) :
	if can_move:
		move()
		
	##so first checks if blackboard has registered the jump input being made,
	## then checks blackboard for the current jump counter, makes sure theres no concessive jumps
	if player.is_on_floor():
		if can_jump && blackboard.get_var(BBNames.jump_var) && blackboard.get_var(BBNames.jumps_made_var) == 0:
			jump()
			
	elif not on_first_frame :
		dispatch("in_air")	
			
	if not player.is_on_floor():
		dispatch("in_air")


#the move function
func move() -> Vector2:
	#pulls the direction var from the bb dictionary
	var direction : Vector2 = blackboard.get_var(BBNames.direction_var)
	var move_speed : float = player_stats.get(movement_speed_var)
	
	#if the movement direction is not approx zero, so closer to -1 or 1
	if not is_zero_approx(direction.x):
		player.velocity.x = direction.x * move_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, move_speed)

	player.move_and_slide()
	return player.velocity
#	
func jump():
	player.velocity.y = -player_stats.jump_velocity
	var current_jumps : int = blackboard.get_var(BBNames.jumps_made_var)
	blackboard.set_var(BBNames.jumps_made_var, current_jumps + 1)
	player.animation_player.play(jump_anim)
	dispatch("jump")
	
