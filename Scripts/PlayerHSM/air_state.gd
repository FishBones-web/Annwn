extends PlayerState

@export var rising_animation: String = "rising"
@export var falling_animation: String = "falling"
@export var jump_animation : String = "jump"
var jump_lock : bool = false

## on the event of "jump" being used to enter the state, calls the func _on_jump
func _setup() -> void:
	add_event_handler("jump", _on_jump)

func _update(_delta: float) -> void:
	air_move()
	select_animation()
	if player.is_on_floor():
		###TODO add in landing animation here
		dispatch("on_ground")
	
##plays animation based on whether the velocity.y is positive or negative(falling or rising)	
func select_animation():
	if jump_lock:
		return
		
	if player.velocity.y <= 0.0:
		player.animation_player.play(rising_animation)
	else:
		player.animation_player.play(falling_animation)
	
	
func air_move() -> Vector2 :
	#pulls the direction var from the bb dictionary
	var direction : Vector2 = blackboard.get_var(BBNames.direction_var)
	
	
	##Acceleration/decceleration capped by max_air_speed
	#move to the right
	if direction.x > 0:
		##add acceleration stat to the current velocity which is capped by the max_air_speed
		var attempted_velocity_x = min(player_stats.max_air_speed, player.velocity.x + player_stats.air_acceleration)
		
		#takes the higher stat of the current velocity.x or attempted_velocity.x
		player.velocity.x = max(player.velocity.x, attempted_velocity_x)
		
	#move to the left
	elif direction.x < 0:
		##add acceleration stat to the current velocity which is capped by the max_air_speed
		var attempted_velocity_x = max(-1 *player_stats.max_air_speed, player.velocity.x - player_stats.air_acceleration)
		
		#takes the smaller stat of the current velocity.x or attempted_velocity.x
		player.velocity.x = min(player.velocity.x, attempted_velocity_x)
		
	
	player.move_and_slide()
	return player.velocity
	
## the func that the even handler calls when everting the state through "jump"
#sets jum_lock to true to lock anyother animation from playing
func _on_jump():
	jump_lock = true
	
#signals from the animation player when the "jump" animation is finished. unlocks the jump lock
##I dont think this actually works yanno
#TODO
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == jump_animation :
		print("jump done")
		jump_lock = false
		
		
