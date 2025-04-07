extends CanvasLayer

@export var player : CharacterBody2D
var save_path = "user://saves/data.save"


func _on_load_pressed() -> void:
	var data = ResourceLoader.load("user://data.res") as Data
	match data.current_scene:
		"Caer_Sidi":
			Global.goto_scene("res://Scenes/World/starting_ruin.tscn")
		"Cauldron_room":
			Global.goto_scene("res://Scenes/World/caer_sidi_cauldron_room.tscn")
		"none":
			print("No scene saved")
			
	player.global_position = data.SavePos
		#TODO ONLY LOADS THE POS FROM FIRST SAVE
	print("loaded")


func _on_save_pressed() -> void:
	var data = Data.new()
	data.SavePos = player.global_position
	
	ResourceSaver.save(data, "user://data.res")
	print("saved")
	
func load_room():
	pass


func _on_negative_health_pressed() -> void:
	var data = ResourceLoader.load("user://data.res") as Data
	data.change_health(20)
	ResourceSaver.save(data, "user://data.res")
	print(data.current_health)


func _on_powerjab_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.pjab_unlocked = true
	elif !toggled_on:
		Global.pjab_unlocked = false


func _on_shield_bash_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.shield_bash_unlocked = true
	elif !toggled_on:
		Global.shield_bash_unlocked = false
