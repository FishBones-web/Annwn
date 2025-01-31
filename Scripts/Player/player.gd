class_name Player
extends CharacterBody2D


@export var sprite : AnimatedSprite2D
@export var player_stats : PlayerStats
@export var player_actions : PlayerActions
@export var animation_player : AnimationPlayer



func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
