class_name Hurtbox
extends Area2D
##where objct can take damage

@export var stats : EnemyStats

func _init() -> void:
	collision_layer = 16
	collision_mask = 0
	
