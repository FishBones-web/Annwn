extends Node2D
var player_inarea_bash = false
var player_inarea_bashdoor = false
var player_inarea_vault = false

@onready var bash_unlock: Area2D = $Bash_unlock
@onready var collision_shape_bash: CollisionShape2D = $mid/bashdoor/CollisionShape2D
@onready var bashdoor: Sprite2D = $mid/bashdoor/Bashdoor

@onready var vault_unlock: Area2D = $vault_unlock
@onready var jab_unlock: Area2D = $jab_unlock




func _process(_delta: float) -> void:
	if player_inarea_bash == true:
		unlock_bash()

func _on_bash_unlock_body_entered(body) -> void:
	if body.has_method("player"):
		player_inarea_bash = true

func unlock_bash():
	bash_unlock.set_visible(false)
	Global.shield_bash_unlocked = true


func _on_vault_unlock_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inarea_vault = true
		unlock_vault()
		
func unlock_vault():
	vault_unlock.set_visible(false)
	Global.vault_unlocked = true


func _on_jab_unlock_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		unlock_pjab()
		
func unlock_pjab():
	jab_unlock.set_visible(false)
	Global.pjab_unlocked = true


func _on_bashdoor_check_area_entered(area: Area2D) -> void:
	if area.has_method("shield_bash"):
		collision_shape_bash.set_deferred("disabled", true)
		bashdoor.set_visible(false)
