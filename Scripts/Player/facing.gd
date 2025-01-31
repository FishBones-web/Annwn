class_name Facing
extends Node2D
## updates the nodes scale to face the left(-1.x) or to the right (+1.x)
##may need to alter this to play a different animation depending on x

@export var player : CharacterBody2D

func _physics_process(_delta: float) -> void:
	if player.velocity.x >0 :
		scale.x = 1.0
	elif player.velocity.x <0 :
		scale.x = -1.0
