extends AirStateBASE

@export var rising_animation: String = "rising"
@export var falling_animation: String = "falling"
@export var jump_animation : String = "jump"
var jump_lock : bool = false

## on the event of "jump" being used to enter the state, calls the func _on_jump
func _setup() -> void:
	add_event_handler("jump", _on_jump)

func _update(delta: float) -> void:
	super(delta) #runs air_move in the daddy script
	select_animation()
	
	if Input.is_action_just_released(BBNames.jump_var) and player.velocity.y < 0:
		player.velocity.y = player.jump_velocity / 4
	
	if blackboard.get_var(BBNames.BJ_var):
		dispatch("lightattack")
	if blackboard.get_var(BBNames.UJ_var):
		dispatch("heavyattack")
		
	if player.is_on_floor() && heavyanimover:
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
		
		
