
extends Resource
class_name Data
###All game data
###just saveable stuff cos fuck, this shit cant be used as player_stats when its not a class

###PLAYER STATS
## keeps all the player stats and variables in one globally accessible place
##mostly for animation
@export var run_speed = 700.0
@export var movement_speed_var = 600
@export var attacking_run_speed : float = 0.0
@export var jump_velocity : float = 800.0
@export var max_air_speed : float = 750.0
@export var air_acceleration : float = 500.0
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

@export var powerjab_unlock : bool = false
@export var shieldbash_unlock : bool = false
@export var downpike_unlock : bool = false

##Position
#saves player pos
@export var SavePos : Vector2

##trying something here w cauldrons
@export var room = "none"
@export var current_scene = "none"

##call this when taking damage
func change_health(value: int):
	current_health -= value
	
func update_pos(value : Vector2):
	SavePos = value
	
	
