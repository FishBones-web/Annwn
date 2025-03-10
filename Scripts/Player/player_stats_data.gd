extends Resource
class_name player_stats_info
##shit

##mostly for animation
@export var run_speed = 600.0
@export var movement_speed_var = 600
@export var attacking_run_speed : float = 0.0

#jumping
#@export var jump_velocity : float = 700.0
@export var max_air_speed : float = 650.0
@export var air_acceleration : float = 400.0


@export var jump_height : float = 400
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.4

@export var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@export var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@export var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var plunge : float = -300
@export var bounce : float = -100

##Combat stuff
@export var current_health : float = 100
@export var max_health : float = 100


@export var jab_damage : float = 20
@export var upwards_jab_damage : float = 25

@export var power_jab_damage : float = 35
@export var shield_bash_damage : float = 15
@export var down_pike_damage : float = 45
