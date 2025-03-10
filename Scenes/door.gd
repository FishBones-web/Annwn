extends Area2D
class_name door_portal

@export var int_UI : Sprite2D
@export var next_scene : StringName
@export var current_scene: StringName
var on_door : bool = false

func _process(_delta: float) -> void:
	if on_door and Input.is_action_just_pressed("interact"):
		print(next_scene)
		if next_scene == "Caer_Sidi":
			Global.goto_scene("res://Scenes/World/starting_ruin.tscn")
		if next_scene == "Cauldron_room":
			Global.goto_scene("res://Scenes/World/caer_sidi_cauldron_room.tscn")
			
		Global.last_scene = current_scene
		
func _on_body_entered(body) -> void:
	print(body)
	if body.has_method("player"):
		on_door = true
		int_UI.set_visible(true)

func _on_body_exited(body) -> void:
	if body.has_method("player"):
		on_door = false
		int_UI.set_visible(false)
