extends PlayerState
##ground state

#lock to prevent switching to airstate before characterbody has a proper chance to detect collision.
var on_first_frame = true


@export var idle_anim : String = "idle"
@export var move_anim : String = "run"
@export var jump_anim : String = "jump"

##if we use the enter func here, the parent enter func wont run. must call super() to run it manually
func _enter() -> void:
	super()
	on_first_frame = true
	blackboard.set_var(BBNames.jumps_made_var, 0)


func _update(_delta: float) -> void:
	var velocity : Vector2 = move()
	
	if Vector2.ZERO.is_equal_approx(velocity):
		player.animation_player.play(idle_anim)
		
	else:
		player.animation_player.play(move_anim)
		
	##so first checks if blackboard has registered the jump input being made,
	## then checks blackboard for the current jump counter, makes sure theres no concessive jumps
	if player.is_on_floor():
		if blackboard.get_var(BBNames.jump_var) && blackboard.get_var(BBNames.jumps_made_var) == 0:
			jump()
			
	elif not on_first_frame :
			dispatch("in_air")	
			
	if blackboard.get_var(BBNames.attack_var):
		dispatch("lightattack")
	if blackboard.get_var(BBNames.heavyattack_var):
		dispatch("heavyattack")
			
	on_first_frame = false

#the move function
func move() -> Vector2:
	#pulls the direction var from the bb dictionary
	var direction : Vector2 = blackboard.get_var(BBNames.direction_var)
	
	#if the movement direction is not approx zero, so closer to -1 or 1
	if not is_zero_approx(direction.x):
		player.velocity.x = direction.x * player_stats.run_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player_stats.run_speed)

	player.move_and_slide()
	return player.velocity
#	
func jump():
	player.velocity.y = -player_stats.jump_velocity
	var current_jumps : int = blackboard.get_var(BBNames.jumps_made_var)
	blackboard.set_var(BBNames.jumps_made_var, current_jumps + 1)
	player.animation_player.play(jump_anim)
	dispatch("jump")
