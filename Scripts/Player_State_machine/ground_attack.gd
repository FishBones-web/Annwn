extends GroundStateBASE
##ground attack state, currently handles light and heavy attacks. light attacks can be chained twice and can also follow
##up with a heavy attack

#light attacks
@export var attack_1 : String
@export var attack_2 : String

#heavy attack
@export var attack_3 : String


func _enter():
	super()
	if Input.is_action_just_pressed("light_attack"):
		_on_lightattack()
	elif Input.is_action_just_pressed("heavy_attack"):
		_on_heavyattack()
	player.animation_player.animation_finished.connect(_on_animation_finished)
	
	
func _exit() -> void:
	player.animation_player.animation_finished.disconnect(_on_animation_finished)
	blackboard.set_var(BBNames.heavyattack_var, false)
	blackboard.set_var(BBNames.attack_var, false)
	
func _on_lightattack():
	player.animation_player.play(attack_1)
	blackboard.set_var(BBNames.attack_var, false)
	
func _on_heavyattack():
	player.animation_player.play(attack_3)
	blackboard.set_var(BBNames.heavyattack_var, false)
	

##handles the chaining of attacks. match the above var(ie attack_2) to the next animation to play
#blackboard section is checking for lack of continued input
func _on_animation_finished(p_animation : String):
	if not blackboard.get_var(BBNames.attack_var) and not blackboard.get_var(BBNames.heavyattack_var):
		dispatch("finished")
		return
	
	#copy the below to chain more attacks	
	
	##this is the chained light attack.
	if blackboard.get_var(BBNames.attack_var):
		match p_animation:
			attack_1:
				player.animation_player.play(attack_2)
				blackboard.set_var(BBNames.attack_var, false)
					
			_:
				dispatch("finished")
				return
				
	##if a heavy attack is attempted to be performed after either lightattack is finishing			
	if blackboard.get_var(BBNames.heavyattack_var):
		match p_animation:
			attack_1:
				player.animation_player.play(attack_3)
				blackboard.set_var(BBNames.heavyattack_var, false)
				
			attack_2:
				player.animation_player.play(attack_3)
				blackboard.set_var(BBNames.heavyattack_var, false)
			
			_:
				dispatch("finished")
				return
				

	
	
		
	
