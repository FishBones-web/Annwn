class_name Facing
extends Node2D
## updates the nodes scale to face the left(-1.x) or to the right (+1.x)
##may need to alter this to play a different animation depending on x

@export var limbo_hsm : LimboHSM

var blackboard : Blackboard

func _ready():
	blackboard = limbo_hsm.blackboard

func _physics_process(_delta: float) -> void:
	var current_input_direction : Vector2 = blackboard.get_var(BBNames.direction_var)
	if current_input_direction.x >0 :
		scale.x = 1.0
	elif current_input_direction.x <0 :
		scale.x = -1.0
