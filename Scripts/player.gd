extends CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var deal_damage_zone: Area2D = $DealDamage

const SPEED = 200
const JUMP_VELOCITY = -350.0

var gravity = 900
var fall_gravity = 1400

var in_transition_anim = false
var attack_type: String
var current_attack: bool
var weapon_equip = true

var can_take_damage: bool
var health = 150
var max_health = 150
var min_health = 0

var dead : bool 

func player():
	pass 
	
func _ready():
	current_attack = false
	Global.playerBody = self
	dead = false
	can_take_damage = true
	Global.playerAlive = true
	
func get_fall_gravity(velocity: Vector2):
		if velocity.y < 0:
			return gravity
		return fall_gravity
		
func _physics_process(delta: float) -> void:
	var weapon_equip = Global.playerWeaponEquip
	Global.playerDamageZone = deal_damage_zone
	Global.playerHitbox = $PlayerHitbox
	
	if not is_on_floor():
		velocity.y += get_fall_gravity(velocity) * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	##this makes gravity nicer, less floaty
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4
		
			
	var direction = Input.get_axis("move_left", "move_right")	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	##checks if a weapon is equipped and not currently in an attack. 
	#then waits for input key and assigns an attack type to the key pressed
	if weapon_equip and !current_attack:
		if Input.is_action_just_pressed("Z") or Input.is_action_just_pressed("X"):
			print("input registered")
			current_attack = true
			if Input.is_action_just_pressed("Z") and is_on_floor():
				print("Z")
				attack_type = "single"
			elif Input.is_action_just_pressed("X") and is_on_floor():
				print("X")
				attack_type = "double"
			else:
				print("A")
				attack_type = "air"
			set_damage(attack_type)
			handle_attack_animation(attack_type)
			
			
	move_and_slide()
	handle_movement_animation(direction)
	
func check_hitbox():
	var hitbox_areas = $PlayerHitbox.get_overlapping_areas()
	var damage: int
	if hitbox_areas:
		var hitbox = hitbox_areas.front()
		if hitbox.get_parent() is FrogEnemy:
			damage = Global.frog_DamageAmount
			
	if can_take_damage:
		take_damage(damage)
		
func take_damage(damage):
	if damage != 0:
		if health > 0:
			health -= damage
			print("player health: ", health)
			if health <= 0:
				health = 0
				dead = true
				handle_death_animation()
			take_damage_cooldown(1.0)
			
func handle_death_animation():
	$CollisionShape2D.position.y = 5
	animated_sprite.play("die")
	await get_tree().create_timer(0.5).timeout
	Global.playerAlive = false
	await get_tree().create_timer(3.0).timeout
	self.queue_free()
	
func take_damage_cooldown(wait_time):
	can_take_damage = false
	await get_tree().create_timer(wait_time).timeout
	can_take_damage = true
	
##all movement animation. 
func handle_movement_animation(dir):
	if !weapon_equip:
		if is_on_floor():
			if !velocity:
				animated_sprite.play("idle")
			if velocity:
				animated_sprite.play("run")
				toggle_flip_sprite(dir)
				
		elif !is_on_floor():
			animated_sprite.play("jump")
			in_transition_anim = true
	if weapon_equip:
		if is_on_floor() and !current_attack:
			if !velocity:
				animated_sprite.play("weapon_idle")
			if velocity:
				animated_sprite.play("weapon_run")
				toggle_flip_sprite(dir)
				
			if Input.is_action_just_pressed("crouch"):
				animated_sprite.play("weapon_crouch")
				
		elif !is_on_floor() and !current_attack:
			animated_sprite.play("weapon_fall")

#flips sprite depending on direction. also flips attack collision zone
func toggle_flip_sprite(dir):
	if dir == 1:
		animated_sprite.flip_h = false
		deal_damage_zone.scale.x = 1
	if dir == -1:
		animated_sprite.flip_h = true
		deal_damage_zone.scale.x = -1
		
##checks the current attack being performed and assigns the correct animation.
##attack_type name must line up with that animation name for this to work
func handle_attack_animation(attack_type):
	if weapon_equip:
		if current_attack:
			var animation =str(attack_type, "_attack")
			print(animation)
			animated_sprite.play(animation)
			toggle_damage_collisions(attack_type)
			
##toggles the damage collision on for a set time when an attack is performed
func toggle_damage_collisions(attack_type):
	var damage_zone_collision = deal_damage_zone.get_node("CollisionShape2D")
	var wait_time: float
	#wait time = frames * by fps
	if attack_type == "air":
		wait_time = 0.6
	elif attack_type == "single":
		wait_time = 0.4
	elif attack_type == "double":
		wait_time = 0.7
	damage_zone_collision.disabled = false
	await get_tree().create_timer(wait_time).timeout
	damage_zone_collision.disabled = true
	
	
# sets a number to the attack just performed and updates the global script with that number
func set_damage(attack_type):
	var current_damage_to_deal: int
	if attack_type == "single":
		current_damage_to_deal = 8
	elif attack_type == "double":
		current_damage_to_deal = 16
	elif attack_type == "air":
		current_damage_to_deal = 20
	Global.playerDamageAmount = current_damage_to_deal

##signal from animatedsprite node when certain animations are finished
func _on_animated_sprite_2d_animation_finished():
	if (animated_sprite.animation == "jump"):
		animated_sprite.play("fall")
		in_transition_anim = false
		
	if (animated_sprite.animation == "single_attack"):
		current_attack = false
	if (animated_sprite.animation == "double_attack"):
		current_attack = false
	if (animated_sprite.animation == "air_attack"):
		current_attack = false


func _on_player_hitbox_area_entered(area: Area2D) -> void:
	if area == Global.frog_DamageZone:
		var damage = Global.frog_DamageAmount
		take_damage(damage)
