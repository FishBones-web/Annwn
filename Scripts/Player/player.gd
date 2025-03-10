class_name Player
extends CharacterBody2D
@onready var debug_menu: CanvasLayer = $"Debug Menu"


var save_file_path = "user://save/"
var save_file_name = "TestSave.tres"
var player_stats = Data.new()
##playerstats is your playerdata
##TODO aight think ive sussed this:
#from the front end on new game creation, do .new(). Have the above changed to load it(confirmed this works)
#ResourceLoader.load("user://data.res") as Data

@export var sprite : AnimatedSprite2D
@export var player_actions : PlayerActions
@export var animation_player : AnimationPlayer

@export var jump_height : float = 300
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.4
@onready var coyote_timer: Timer = $CoyoteTimer
@export var can_coyote_jump = false

@export var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@export var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@export var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0


func player():
	pass

func _physics_process(delta: float) -> void:

	# Add the gravity.
	if not is_on_floor() && !can_coyote_jump:
		velocity.y += cus_get_gravity() * delta
		
	if Input.is_action_just_pressed(player_actions.debug):
		if debug_menu.is_visible():
			debug_menu.set_visible(false)
		else:
			debug_menu.set_visible(true)
		
func cus_get_gravity() -> float:
	if velocity.y < 0.0:
		return jump_gravity
	else:
		return fall_gravity
	#return player_stats.jump_gravity if velocity.y < 0.0 else player_stats.fall_gravity
			

func _on_coyote_timer_timeout() -> void:
	can_coyote_jump = false
