class_name Hurtbox
extends Area2D
##where objct can take damage

@export var stats : Stats

##this is if the hurting one is the player
##too scared to combine the 2 stat classes
@export var playerstats : Data
@export var body : CharacterBody2D

func _init() -> void:
	collision_layer = 16
	collision_mask = 0
	
