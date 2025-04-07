extends Node2D

const Cauldron_room_scene_path : String  = "res://Scenes/caer_sidi_cauldron_room.tscn"
var data = ResourceLoader.load("user://data.res") as Data
@export var player : CharacterBody2D
@export var hall_spikes_obj : AnimatedSprite2D
@onready var hall_door: AnimatedSprite2D = $EnvironmentBack/Smaller_rooms/Hall/Hall_door
@onready var collision_shape_hall: CollisionShape2D = $EnvironmentBack/Smaller_rooms/Hall/hall_spikes/CollisionShape2D
@onready var caer_door_dect: door_portal = $CaerDoorDect


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
		
	if Global.Cauldron_room_lock == false:
		caer_door_dect.already_unlocked()

func _on_teleport_to_upper_body_entered(body) -> void:
	if body.has_method("player"):
		player.position.x = Global.player_upperhall_posx
		player.position.y = Global.player_upperhall_posy

func _on_teleport_from_upper_body_entered(body) -> void:
	if body.has_method("player"):
		player.position.x = Global.player_study_posx
		player.position.y = Global.player_study_posy
