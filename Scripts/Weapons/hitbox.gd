class_name Hitbox
extends Area2D
##does damage

##this is used if the hitbox belongs to player
@export var weapon_stats : WeaponStats

#this one if for if the box belongs to an enemy
@export var enemy_stats : Stats

@export var body : CharacterBody2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(p_area : Area2D):
	var hurtbox = p_area as Hurtbox
	if not hurtbox:
		return
		
	##if the thing about to be damaged is the player
	if hurtbox.body.has_method("player"):
		#if the attacker is also the player it cancels out
		if body.has_method("player"):
			return
		else:
			if hurtbox.body.can_take_dam:
					hurtbox.playerstats.just_took_dam = true
					Global.just_took_dam = true
					hurtbox.playerstats.current_health -= enemy_stats.damage
					hurtbox.playerstats.knockback_dir = enemy_stats.last_moved_dir
					hurtbox.playerstats.knockback_x = 300
					hurtbox.playerstats.knockback_y = -450

		return
		
		
	#if the thing about to be hurt is an enemy
	if hurtbox.body.has_method("enemy"):
		#if the attacker is also an enemy it cancels out
		if body.has_method("enemy"):
			return
			
		##this will run the player attacking the enemy
		else:
				if hurtbox.body.can_take_dam:
					hurtbox.stats.just_took_dam = true
					hurtbox.stats.current_health -= weapon_stats.damage
					hurtbox.stats.knockback_dir = Global.last_moved_dir
					print("enemy currently has ", hurtbox.stats.current_health, " health")
					print("dealt ", weapon_stats.damage, " damage. Using the ", weapon_stats.display_name, " attack")
	
					if weapon_stats.display_name == "basic_jab":
						hurtbox.stats.knockback_x = 400
		
					elif weapon_stats.display_name == "upwards_jab":
						hurtbox.stats.knockback_x = 300
						hurtbox.stats.knockback_y = -450
		
					elif weapon_stats.display_name == "shield_bash":
						hurtbox.stats.knockback_x = 800
						print("enemy detected in hitbox range")
	
	

	
