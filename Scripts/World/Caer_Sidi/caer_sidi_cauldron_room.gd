extends Node2D

const Caer_Sidi_scene_path : String  = "res://Scenes/World/starting_ruin.tscn"
var data = ResourceLoader.load("user://data.res") as Data
@export var player = CharacterBody2D
@export var blocker : StaticBody2D
@export var blocker2 : Sprite2D
@export var spike_collision : CollisionShape2D


func _ready():
	Global.preload_scene(Caer_Sidi_scene_path)
	Global.Cauldron_room_lock = false
	
func _process(_delta: float) -> void:
	if Global.cauldron_room_spikes == false:
		blocker.set_visible(false)
		blocker2.set_visible(false)
		spike_collision.set_deferred("disabled", true)
	
	
		
