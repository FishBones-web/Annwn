class_name Stats
extends Resource
## keeps all the enemy stats and variables in one globally accessible place

@export var jump_power : float = -400.0
@export var gravity : float = 50

@export var max_health : int = 80
@export var current_health: int  = 80

@export var damage : int = 20
@export var last_moved_dir : int

##recieved knockback 
@export var knockback_x: int = 0
@export var knockback_y: int = 0
##this one gets updated with what direction the player was moving/facing to know what direction to knockback
@export var knockback_dir: Vector2
@export var bashed: bool = false

@export var just_took_dam : bool = false
