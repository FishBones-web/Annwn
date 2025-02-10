extends BTAction

##remember this is stored as a bool
@export var hunger_meter_var : StringName = "hungry"

@export var hunger_meter_var_float : StringName = "hunger_meter_var_float"

func _tick(delta: float) -> Status:
	var hunger_meter = blackboard.get_var(hunger_meter_var)
	var hunger_meter_float = blackboard.get_var(hunger_meter_var_float)
	agent.refil_hunger()
	print(hunger_meter)
	print(hunger_meter_float)
	return SUCCESS
