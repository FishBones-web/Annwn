class_name Hitbox
extends Area2D
##does damage

@export var weapon_stats : WeaponStats

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(p_area : Area2D):
	var hurtbox = p_area as Hurtbox
	if not hurtbox:
		return
		
	hurtbox.stats.current_health -= weapon_stats.damage
	print(hurtbox.stats.current_health)
	print(weapon_stats.damage)
	
	
