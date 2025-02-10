extends GroundStateBASE

##blocking state
##right now the state can be triggered but has no practical collsion and the user cannot exit the state
#TODO needs timer for blocking length and a key just released func to end block state. Also needs area2d and collsionshape

##these are the anims
@export var block : String
@export var blocking_cont : String

@export var currently_blocking : bool = false


func _enter():
	super()
	currently_blocking = true
	player.animation_player.animation_finished.connect(_on_animation_finished)
	
func _exit() -> void:
	player.animation_player.animation_finished.disconnect(_on_animation_finished)
	blackboard.set_var(BBNames.block_var, false)
	
func _update(p_delta: float) -> void:
	super(p_delta)
	
	if blackboard.get_var(BBNames.attack_var):
		pass
	if blackboard.get_var(BBNames.heavyattack_var):
		pass


func _on_animation_finished(p_animation : String):
		match p_animation:
			block:
				currently_blocking = false
				dispatch("finished") # nothing happened block
				
			_:
				currently_blocking = false
				dispatch("finished")
				return
