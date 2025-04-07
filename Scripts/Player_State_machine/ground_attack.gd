extends GroundStateBASE
##ground attack state, currently handles basic jab and upwards jab attacks. cabibilities to  be chained twice and can also follow
##up with an upwards jab are here. need tweaking
@onready var bash_timer: Timer = %BashTimer
@onready var bash_cooldown: Timer = %BashCooldown


@export var weapon_stats : WeaponStats
##change weapon_Stats.damage on each attack input.
## values
# Heavyattack = 40
# LightAttack = = 20
@export var light_damage : float = 20
@export var heavy_damage : float = 20
@export var bash_damage : float = 25

#basic jab attacks
@export var attack_1 : String
@export var attack_2 : String ##this is defunct as of now

#upwards jab attack
@export var attack_3 : String

##bash attach
@export var attack_4 : String
@export var can_bash : bool = true


func _enter():
	super()
	if Input.is_action_just_pressed("basic_jab"):
		_on_lightattack()
	if Input.is_action_just_pressed("upwards_jab"):
		_on_heavyattack()
	elif Input.is_action_just_pressed("shield_bash"):
		_on_shieldbash()
	player.animation_player.animation_finished.connect(_on_animation_finished)
	
func _update(p_delta: float) -> void:
	super(p_delta)
	
	if Global.bashed_wall:
		dispatch("bashed")
		
	if Global.bashed_enemy:
		dispatch("bashed")
		
func _exit() -> void:
	weapon_stats.damage = 20
	player.animation_player.animation_finished.disconnect(_on_animation_finished)
	blackboard.set_var(BBNames.UJ_var, false)
	blackboard.set_var(BBNames.BJ_var, false)

##basic jab	
func _on_lightattack():
	weapon_stats.damage = light_damage
	weapon_stats.display_name = "basic_jab"
	player.animation_player.play(attack_1)
	blackboard.set_var(BBNames.BJ_var, false)

#upwards jab	
func _on_heavyattack():
	weapon_stats.damage = heavy_damage
	weapon_stats.display_name = "upwards_jab"
	player.animation_player.play(attack_3)
	blackboard.set_var(BBNames.UJ_var, false)
	
#shield bash
func _on_shieldbash():
	weapon_stats.damage = bash_damage
	weapon_stats.display_name = "shield_bash"
	can_move = false
	bash_timer.start()
	movement_speed_var *= 10
	player.velocity.x = Global.last_moved_dir.x * movement_speed_var
	player.animation_player.play(attack_4)
	blackboard.set_var(BBNames.bash_var,false)
	Global.bash_ready = false
	bash_cooldown.start()
	
func bash_over():
	pass
	
	
	

##handles the chaining of attacks. match the above var(ie attack_2) to the next animation to play
#blackboard section is checking for lack of continued input
func _on_animation_finished(p_animation : String):
	if not blackboard.get_var(BBNames.BJ_var) and not blackboard.get_var(BBNames.UJ_var):
		dispatch("finished")
		return
	
	#copy the below to chain more attacks	
	
	##this is the chained light attack.
	if blackboard.get_var(BBNames.BJ_var):
		match p_animation:
			attack_1:
				player.animation_player.play(attack_2)
				blackboard.set_var(BBNames.BJ_var, false)
					
			_:
				dispatch("finished")
				return
				
	##if a heavy attack is attempted to be performed after either lightattack is finishing			
	if blackboard.get_var(BBNames.UJ_var):
		weapon_stats.damage = 40
		match p_animation:
			attack_1:
				player.animation_player.play(attack_3)
				blackboard.set_var(BBNames.UJ_var, false)
				
			attack_2:
				player.animation_player.play(attack_3)
				blackboard.set_var(BBNames.UJ_var, false)
			
			_:
				dispatch("finished")
				return
				


func _on_bash_timer_timeout() -> void:
	movement_speed_var = 600
	can_move = true
