extends GroundStateBASE
##ground state


##if we use the enter func here, the parent enter func wont run. must call super() to run it manually
func _enter() -> void:
	super()
	on_first_frame = true
	blackboard.set_var(BBNames.jumps_made_var, 0)


func _update(p_delta: float) -> void:
	super(p_delta)
	
	if Vector2.ZERO.is_equal_approx(player.velocity):
		player.animation_player.play(idle_anim)
		
	else:
		player.animation_player.play(move_anim)
		
			
	if blackboard.get_var(BBNames.attack_var):
		dispatch("lightattack")
	if blackboard.get_var(BBNames.heavyattack_var):
		dispatch("heavyattack")
			
	if blackboard.get_var(BBNames.block_var):
		dispatch("blockraise")
		
	on_first_frame = false
	
