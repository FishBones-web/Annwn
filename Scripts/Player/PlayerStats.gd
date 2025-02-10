class_name PlayerStats
extends Resource
## keeps all the player stats and variables in one globally accessible place

@export var run_speed : float = 300.0
@export var attacking_run_speed : float = 0.0
@export var jump_velocity : float = 400.0
@export var max_air_speed : float = 250.0
@export var air_acceleration : float = 200.0

@export var plunge : float = -300

##little bounce nice
@export var bounce : float = -100
