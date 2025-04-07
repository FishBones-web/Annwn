extends LimboHSM
##state machine

@export var player : CharacterBody2D

@export var GroundState : LimboState
@export var GroundAttackState : LimboState

@export var AirState : LimboState
@export var AirAttackState : LimboState

@export var BlockState : LimboState




func _ready() -> void:
	##calls the binding setup func
	_binding_setup()
	##initialize creates the machine, player is in it's purse to tell it what agent its using
	initialize(player)
	set_active(true)
	

##handles the transitions between states
## names starting state, then the state it transitions to, then the name of the condition that causes the switch
func _binding_setup():
	add_transition(GroundState, AirState, "in_air")
	add_transition(AirState, GroundState, "on_ground")
	add_transition(GroundState, AirState, "jump")
	
	add_transition(GroundState, GroundAttackState, "lightattack")
	add_transition(GroundState, GroundAttackState, "heavyattack")
	add_transition(GroundAttackState, GroundState, "finished")
	add_transition(GroundAttackState, AirState, "in_air")
	add_transition(GroundAttackState, AirState, "jump")
	
	add_transition(AirState, AirAttackState, "lightattack")
	add_transition(AirState, AirAttackState, "heavyattack")
	add_transition(AirAttackState, AirState, "finished")
	add_transition(AirAttackState, GroundState, "on_ground")
	
	add_transition(GroundState, BlockState, "blockraise")
	add_transition(BlockState, GroundState, "finished")
	
	add_transition(GroundState, GroundAttackState, "shieldbash")
	add_transition(GroundAttackState, AirState, "bashed")
	
	add_transition(GroundState, AirState, "vault")
	

####
