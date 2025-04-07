extends PlayerState
class_name AirStateBASE

@export var can_move : bool = true
@export var heavyanimover : bool = true

func _update(_delta: float) -> void:
	if player_stats.just_took_dam:
		can_move = false 
	elif !player_stats.just_took_dam:
		can_move = true
		
	if can_move:
		air_move()
	
	if player.is_on_floor() && heavyanimover:
		###TODO add in landing animation here
		dispatch("on_ground")

func air_move() -> Vector2 :
	#pulls the direction var from the bb dictionary
	var direction : Vector2 = blackboard.get_var(BBNames.direction_var)
	
	
	##Acceleration/decceleration capped by max_air_speed
	#move to the right
	if direction.x > 0 && heavyanimover:
		##add acceleration stat to the current velocity which is capped by the max_air_speed
		var attempted_velocity_x = min(player_stats.max_air_speed, player.velocity.x + player_stats.air_acceleration)
		
		#takes the higher stat of the current velocity.x or attempted_velocity.x
		player.velocity.x = max(player.velocity.x, attempted_velocity_x)
		
	#move to the left
	elif direction.x < 0 && heavyanimover:
		##add acceleration stat to the current velocity which is capped by the max_air_speed
		var attempted_velocity_x = max(-1 *player_stats.max_air_speed, player.velocity.x - player_stats.air_acceleration)
		
		#takes the smaller stat of the current velocity.x or attempted_velocity.x
		player.velocity.x = min(player.velocity.x, attempted_velocity_x)
		
	
		
	player.move_and_slide()
	return player.velocity
