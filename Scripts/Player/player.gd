class_name Player
extends CharacterBody2D
@onready var debug_menu: CanvasLayer = $"Debug Menu"


var save_file_path = "user://save/"
var save_file_name = "TestSave.tres"
@export var player_stats = Data.new()
##playerstats is your playerdata
##TODO aight think ive sussed this:
#from the front end on new game creation, do .new(). Have the above changed to load it(confirmed this works)
#ResourceLoader.load("user://data.res") as Data

@export var sprite : AnimatedSprite2D
@export var player_actions : PlayerActions
@export var animation_player : AnimationPlayer

@export var jump_height : float = 200
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.4
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var damage_cooldown: Timer = %DamageCooldown

@export var can_coyote_jump = false
@export var can_take_dam = true

@onready var bash_collision: CollisionShape2D = $Facing/Shield_Bash_area/CollisionShape2D


@export var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@export var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@export var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@export var vault_height : float = 300
@export var vault_time_to_peak : float = 0.5

@export var vault_velocity : float = ((2.0 * vault_height) / vault_time_to_peak) * -1.0
@export var vault_gravity : float = ((-2.0 * vault_height) / (vault_time_to_peak * vault_time_to_peak)) * -1.0


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
			
	handle_damage()
		
func cus_get_gravity() -> float:
	if velocity.y < 0.0:
		return jump_gravity
	else:
		return fall_gravity
			

func _on_coyote_timer_timeout() -> void:
	can_coyote_jump = false

func _on_jump_timer_timeout() -> void:
	Global.jump_lock = false	

func _on_bash_cooldown_timeout() -> void:
	print("bash ready")
	Global.bash_ready = true

func handle_damage():
	if player_stats.just_took_dam and can_take_dam:
		print("player has been hit")
		update_health()
		can_take_dam = false
		player_stats.just_took_dam = false
		var endir = player_stats.knockback_dir
		velocity.x = endir * player_stats.knockback_x
		velocity.y = player_stats.knockback_y
		await get_tree().create_timer(0.12).timeout
		velocity.x = 0
		velocity.y = 0
		player_stats.knockback_x = 0
		player_stats.knockback_y = 0
		damage_cooldown.start()
		
func _on_damage_cooldown_timeout() -> void:
	can_take_dam = true
	Global.just_took_dam = false

#updates current health(and max health) to the global for the UI to pull from
func update_health():
	Global.current_health = player_stats.current_health
	Global.max_health = player_stats.max_health
