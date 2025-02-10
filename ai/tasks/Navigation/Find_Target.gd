extends BTAction

##what group the entity is looking for
@export var group: StringName
@export var target_var : StringName = &"target"

var target

func _tick(_delta: float) -> Status:
	if group == "Test_enemy":
		target = get_enemy_node()
	if group == "Player":
		target = get_player_node()
	if group == "food_test":
		target = get_foilage_node()
	blackboard.set_var(target_var, target)
	return SUCCESS
		
##pulls all the group nodes in the current scene, puts them in an array. 
func get_enemy_node():
	var nodes: Array[Node] = agent.get_tree().get_nodes_in_group(group)
	if nodes.size() >= 2:
##gets the agent to run the check_for_self func, if it returns true shuffles the array of scene nodes until it returns false
		while agent.check_for_self(nodes.front()):
			nodes.shuffle()
		return nodes.front()

##checks the nodes in scene for which are in group "player"
func get_player_node():
	var nodes: Array[Node] = agent.get_tree().get_nodes_in_group(group)
	return nodes[0]
	
func get_foilage_node():
	var nodes: Array[Node] = agent.get_tree().get_nodes_in_group(group)
	print(nodes)
	return nodes.front()
