extends PlayerState

#light attacks
@export var attack_1 : String
@export var attack_2 : String

#heavy attack
@export var attack_3 : String

func _enter():
	super()
	add_event_handler("heavyattack", _on_heavyattack)
	if "heavyattack":
		_on_heavyattack()
	
	add_event_handler("lightattack", _on_lightattack)
	if "lightattack":
		_on_lightattack()
	
	
func _exit() -> void:
	player.animation_player.animation_finished.disconnect(_on_animation_finished)
	blackboard.set_var(BBNames.heavyattack_var, false)
	
func _on_heavyattack():
	player.animation_player.play(attack_3)
	player.animation_player.animation_finished.connect(_on_animation_finished)

	
func _on_lightattack():
	player.animation_player.play(attack_1)
	player.animation_player.animation_finished.connect(_on_animation_finished)
	blackboard.set_var(BBNames.attack_var, false)

##handles the chaining of attacks. match the above var(ie attack_2) to the next animation to play
#blackboard section is checking for lack of continued input
func _on_animation_finished(p_animation : String):
	if not blackboard.get_var(BBNames.attack_var):
		dispatch("finished")
		return
	
	###currently heavy cannot chain is its the first anim performed.
	
	#copy the below to chain more attacks	
	##this is the chained light attack
	if blackboard.get_var(BBNames.attack_var):
		match p_animation:
			attack_1:
				player.animation_player.play(attack_2)
				blackboard.set_var(BBNames.attack_var, false)
			
			##after performing the second light attack, the heavy attack is performed if key is pressed
				if attack_2 and blackboard.get_var(BBNames.heavyattack_var):
					player.animation_player.play(attack_3)
					blackboard.set_var(BBNames.heavyattack_var, false)
					
			#if attack 2 isnt the anim just finished, ends state
			_:
				dispatch("finished")
				return
				

	
	
		
	
