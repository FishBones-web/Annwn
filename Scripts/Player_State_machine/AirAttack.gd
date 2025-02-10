extends AirStateBASE
##ground attack state, currently handles light and heavy attacks. light attacks can be chained twice and can also follow
##up with a heavy attack. Heavy attack can be performed independently too but does not chain as intended

###TODO animations are currently too fast and look weird. Also apply big gravity to heavy attack to ensure it doesnt end mid air

#light attacks
@export var attack_1 : String
@export var attack_2 : String
@export var attack_3 : String

#heavy attack
@export var attack_4 : String


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
	heavyanimover = false
	plunge()
	player.animation_player.play(attack_4)
	blackboard.set_var(BBNames.heavyattack_var, true)
	
	
##plunges player down on heavy attack
#TODO needs tweaking
func plunge():
	player.velocity.y = -player_stats.plunge
	
func bounce():
	player.velocity.y = +player_stats.bounce	

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
				
			attack_2:
				player.animation_player.play(attack_3)
				blackboard.set_var(BBNames.attack_var, false)
					
			_:
				dispatch("finished")
				return
				
	##if a heavy attack is attempted to be performed after either lightattack is finishing			
	if blackboard.get_var(BBNames.heavyattack_var):
		match p_animation:
			attack_1:
				plunge()
				player.animation_player.play(attack_4)	
				
			attack_2:
				plunge()
				player.animation_player.play(attack_4)
				
				
			attack_3:
				plunge()
				player.animation_player.play(attack_4)
				
func heavyover():
	heavyanimover = true
	dispatch("finished")
	return
				
				

	
