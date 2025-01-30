class_name PlayerActions
extends Resource

##keeps track of the different player inputs/actions and stores them here in a globally accessible script
#Like a dictionary but if any names or actions are changed here, they change everywhere.

@export var move_left : String = "move_left"
@export var move_right : String = "move_right"
@export var up : String = "up"
@export var down : String = "down"
@export var jump : String = "jump"

@export var swing1 : String = "swing1"
@export var swing2 : String = "swing2"
