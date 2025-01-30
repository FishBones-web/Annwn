extends Label
##shows current state of state machine

@export var limbo_hsm : LimboHSM :
	set(value):
		if limbo_hsm != null:
			limbo_hsm.active_state_changed.disconnect(on_active_state_changed)
			
		limbo_hsm = value
		
		if limbo_hsm != null:
			var current_state = limbo_hsm.get_active_state()
			
			if current_state != null:
				text  = current_state.name
				
			limbo_hsm.active_state_changed.connect(on_active_state_changed)
			
func on_active_state_changed(current: LimboState, _previous : LimboState):
	text = current.name
