extends Area2D

@export var weapon_stats : WeaponStats
@export var player : CharacterBody2D


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	
func _on_area_entered(p_area : Area2D):
	var hurtbox = p_area as Hurtbox
	if not hurtbox:
		return
		
	hurtbox.stats.just_took_dam = true
	hurtbox.stats.current_health -= weapon_stats.damage
	print("enemy currently has ", hurtbox.stats.current_health, " health")
	print("dealt ", weapon_stats.damage, " damage. Using the ", weapon_stats.display_name, " attack")
		
	if weapon_stats.display_name == "shield_bash":
		hurtbox.stats.bashed = true
		hurtbox.stats.knockback_x = 800
	
	Global.bashed_enemy = true

##this is needed to open doors	
func shield_bash():
	pass
	


func _on_body_entered(body) -> void:
	var layer = body.get_collision_layer()
	if layer == 1:
		print("collision detected", body)
		Global.bashed_wall = true
		return
	else:
		return
