extends AirStateBASE
@onready var jump_timer: Timer = %JumpTimer

@export var rising_animation: String = "rising"
@export var peak_jump_animation: String = "peak_jump"
@export var falling_animation: String = "falling"

@export var wall_bash_animation: String = "wall_bash"


## on the event of "jump" being used to enter the state, calls the func _on_jump
func _setup() -> void:
	pass
	
func _enter() -> void:
	super()
	if Input.is_action_just_pressed("vault"):
		vault()
		
	if Global.bashed_wall:
		wallbash()
		Global.bashed_wall = false
		
	if Global.bashed_enemy:
		shield_bash()
		Global.bashed_enemy = false

func _update(delta: float) -> void:
	super(delta) #runs air_move in the daddy script
	select_animation()
	
	if Input.is_action_just_released(BBNames.jump_var) and player.velocity.y < 0:
		player.velocity.y = player.jump_velocity / 4
	
	if blackboard.get_var(BBNames.BJ_var):
		dispatch("lightattack")
	if blackboard.get_var(BBNames.UJ_var):
		dispatch("heavyattack")
		
	if player.is_on_floor():
		###TODO add in landing animation here
		Global.jump_lock = true
		jump_timer.start()
		dispatch("on_ground")
	
##plays animation based on whether the velocity.y is positive or negative(falling or rising)	
func select_animation():
		
	if player.velocity.y <= 0.0:
		player.animation_player.play(rising_animation)
	#elif player.velocity.y == 0.0:
		#player.animation_player.play(peak_jump_animation)
	elif player.velocity.y >= 0.0:
		player.animation_player.play(falling_animation)
	
	
func vault():
			
	if player.is_on_floor() && heavyanimover:
		###TODO add in landing animation here
		dispatch("on_ground")
		
##this is when u hit a wall during shield bash		
func wallbash():
	player.animation_player.stop()
	player.animation_player.play(wall_bash_animation)
	var dir = Global.last_moved_dir.x
	if dir <= 0.0:
		player.velocity.x = 1 * 900
	elif dir >= 0.0:
		player.velocity.x = -1 * 900
	player.velocity.y = -400
	await get_tree().create_timer(1).timeout
	player.velocity.x = 0
	if player.is_on_floor():
		dispatch("on_ground")
	
##thiis is when hitting an enemy during shielbash
func shield_bash():
	player.animation_player.stop()
	player.animation_player.play(wall_bash_animation)
	var dir = Global.last_moved_dir.x
	if dir <= 0.0:
		player.velocity.x = 1 * 800
	elif dir >= 0.0:
		player.velocity.x = -1 * 800
	player.velocity.y = -200
	await get_tree().create_timer(0.8).timeout
	player.velocity.x = 0
