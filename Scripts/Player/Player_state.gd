class_name PlayerState
extends LimboState

@export var animation_name : String

var player : CharacterBody2D
var player_stats : PlayerStats


#when state is entered
func _enter():
	player = agent as CharacterBody2D
	player.animation_player.play(animation_name)
	player_stats = player.player_stats
	
	
