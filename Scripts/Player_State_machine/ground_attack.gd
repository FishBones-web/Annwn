extends GroundStateBASE
##ground attack state, currently handles basic jab and upwards jab attacks. cabibilities to  be chained twice and can also follow
##up with an upwards jab are here. need tweaking

@export var weapon_stats : WeaponStats
##change weapon_Stats.damage on each attack input.
## values
# Heavyattack = 40
# LightAttack = = 20
@export var light_damage : float = 20
@export var heavy_damage : float = 20

#basic jab attacks
@export var attack_1 : String
@export var attack_2 : String ##this is defunct as of now

#upwards jab attack
@export var attack_3 : String


func _enter():
	super()
	if Input.is_action_just_pressed("basic_jab"):
		_on_lightattack()
	elif Input.is_action_just_pressed("upwards_jab"):
		_on_heavyattack()
	player.animation_player.animation_finished.connect(_on_animation_finished)
	
	
func _exit() -> void:
	weapon_stats.damage = 20
	player.animation_player.animation_finished.disconnect(_on_animation_finished)
	blackboard.set_var(BBNames.UJ_var, false)
	blackboard.set_var(BBNames.BJ_var, false)

##basic jab	
func _on_lightattack():
	weapon_stats.damage = light_damage
	player.animation_player.play(attack_1)
	blackboard.set_var(BBNames.BJ_var, false)

#upwards jab	
func _on_heavyattack():
	weapon_stats.damage = heavy_damage
	player.animation_player.play(attack_3)
	blackboard.set_var(BBNames.UJ_var, false)
	

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
				

	
	
		
	
