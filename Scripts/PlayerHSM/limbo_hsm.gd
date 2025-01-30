extends LimboHSM
##state machine

@export var Player : CharacterBody2D

@export var GroundState : LimboState
@export var AirState : LimboState




func _ready() -> void:
	##calls the binding setup func
	_binding_setup()
	##initialize creates the machine, player is in it's purse to tell it what agent its using
	initialize(Player)
	set_active(true)
	

##handles the transitions between states
## names starting state, then the state it transitions to, then the name of the condition that causes the switch
func _binding_setup():
	add_transition(GroundState, AirState, "in_air")
	add_transition(AirState, GroundState, "on_ground")

####
