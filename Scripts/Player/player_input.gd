class_name PlayerInput
extends Node
## Handles recieving of actions and assigning values to blackboard properties
## every time you add a new input it HAS to go here
## add it to the project input settings, then add it here, 
##and make sure you update the actual blackboard manager in the HSM node

##connects our global player actions dictionary
@export var player_actions : PlayerActions

##connects the HSM
@export var limbo_hsm : LimboHSM

var blackboard : Blackboard

#names the inputs with their type
var input_direction : Vector2
var jump : bool
var L_attack : bool
var H_attack : bool
var blocking : bool

##binds the above input vars to their blackboard property(in BBNames and in the BB manager)
func _ready() -> void:
	#defines blackboard as the blackboard connected to HSM
	blackboard = limbo_hsm.blackboard
	#the actual binding. pull the var from the BBNames script, 
	#applies to self, name of input(must match unless defined as the same here)
	# marks true or false to define if it autoplays
	blackboard.bind_var_to_property(BBNames.direction_var, self, "input_direction", true)
	blackboard.bind_var_to_property(BBNames.jump_var, self, "jump", false)
	blackboard.bind_var_to_property(BBNames.attack_var, self, "L_attack", false)
	blackboard.bind_var_to_property(BBNames.heavyattack_var, self, "H_attack", false)
	blackboard.bind_var_to_property(BBNames.block_var, self, "blocking", false)

func _process(_delta: float) -> void:
	#assigns the inputs of the input_direction. pulls from the player_input dictionarty
	input_direction = Input.get_vector(player_actions.move_left, player_actions.move_right, player_actions.up, player_actions.down)

func _unhandled_input(event: InputEvent) -> void:
	# Handles jump.
	if event.is_action_pressed(player_actions.jump):
		jump = true
	elif event.is_action_released(player_actions.jump):
		jump = false
	
	if Input.is_action_just_pressed(player_actions.light_attack):
		L_attack = true
	if Input.is_action_just_released(player_actions.light_attack):
		L_attack = false
		
	if Input.is_action_just_pressed(player_actions.heavy_attack):
		H_attack = true
	if Input.is_action_just_released(player_actions.heavy_attack):
		H_attack = false
		
	if Input.is_action_just_pressed(player_actions.block):
		blocking = true
	elif Input.is_action_just_released(player_actions.block):
		blocking = false
	
