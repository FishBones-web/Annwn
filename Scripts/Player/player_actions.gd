class_name PlayerActions
extends Resource

##keeps track of the different player inputs/actions and stores them here in a globally accessible script
#Like a dictionary but if any names or actions are changed here, they change everywhere.

@export var move_left : String = "move_left"
@export var move_right : String = "move_right"
@export var up : String = "up"
@export var down : String = "down"
@export var jump : String = "jump"

@export var light_attack : String = "light_attack"
@export var heavy_attack : String = "heavy_attack"
