extends Node2D

const Cauldron_room_scene_path : String  = "res://Scenes/caer_sidi_cauldron_room.tscn"
var data = ResourceLoader.load("user://data.res") as Data
@export var player : CharacterBody2D
@export var hall_spikes_obj : AnimatedSprite2D
@onready var collision_shape_hall: CollisionShape2D = $EnvironmentBack/Smaller_rooms/Hall/hall_spikes/CollisionShape2D

##ayoo swap this shit out for the outdoor area, these little rooms are small, we dont need to preload them

func _ready():
	Global.preload_scene(Cauldron_room_scene_path)
	if Global.fresh_save == true:
		player.position.x = Global.game_start_posx
		player.position.y = Global.game_start_posy
		Global.fresh_save = false
	else:
		match Global.last_scene:
			
			"Cauldron_room":
				player.position.x = Global.player_exit_cauldronroom_posx
				player.position.y = Global.player_exit_cauldronroom_posy
				
func _process(_delta: float) -> void:
	if Global.hall_spikes == false:
		collision_shape_hall.set_deferred("disabled", true)
		hall_spikes_obj.set_visible(false)
		
		
				
			
	
