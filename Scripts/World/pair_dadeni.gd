extends Sprite2D
class_name Pair_Dadeni

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var wood: AnimatedSprite2D = $wood
@onready var pot: AnimatedSprite2D = $pot
@onready var fire: AnimatedSprite2D = $fire


@export var player : CharacterBody2D
var player_inarea : bool = false
var save_path = "user://saves/data.save"
@export var current_scene : String

func _ready() -> void:
	animation_player.play("Unlit")

func _process(_delta: float) -> void:
	if player_inarea and Input.is_action_just_pressed("interact"):
		animation_player.play("Activated")
		var data = ResourceLoader.load("user://data.res") as Data
		data.current_health = data.max_health
		print(data.current_health)
		save()

func _on_interaction_zone_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inarea = true

func _on_interaction_zone_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inarea = false

func save():
	var data = Data.new()
	data.current_scene = current_scene
	data.SavePos = player.global_position
	
	ResourceSaver.save(data, "user://data.res")
	print("saved")
	
