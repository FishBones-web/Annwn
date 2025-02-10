extends BTAction

@export var range_min : float = 40
@export var range_max : float = 100

##saves the desired pos to blackboard. &"var" is like using call_method
@export var position_var: StringName = &"pos"
@export var dir_var: StringName = &"dir"

func _tick(_delta: float) -> Status:
	var pos: Vector2
	var dir = rando_dir()
	
	pos = rando_pos(dir)
	blackboard.set_var(position_var, pos)
	
	return SUCCESS
	
func rando_dir():
	var dir = randi_range(-2, 1)
	if abs(dir) != dir:
		dir = -1
	else:
		dir = 1
	blackboard.set_var(dir_var, dir)
	return dir

func rando_pos(dir):
	var vector: Vector2
	var distance = randi_range(range_min, range_max) * dir
	var final_position = (distance + agent.global_position.x)
	vector.x = final_position
	return vector
