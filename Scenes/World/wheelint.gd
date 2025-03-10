extends Area2D
var on_handle = false
@export var blocker : StaticBody2D
@export var blocker2 : Sprite2D

func _process(_delta: float) -> void:
	if on_handle and Input.is_action_just_pressed("interact"):
		blocker.set_visible(false)
		blocker2.set_visible(false)
		Global.hall_spikes = false
		Global.cauldron_room_spikes = false
		

func _on_body_entered(_body: Node2D) -> void:
	on_handle = true

func _on_body_exited(_body: Node2D) -> void:
	on_handle = false
