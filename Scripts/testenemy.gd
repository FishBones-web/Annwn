# to fix: The frog picks up velocity the more it moves in one direction, making it speed up

extends CharacterBody2D

class_name FrogEnemy
const speed = 10
var gravity = 900
var dir: Vector2

var player: CharacterBody2D
var player_in_area = false
var is_frog_chase: bool = true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var health = 50
var health_max = 50
var health_min = 0
var dead: bool = false
var taking_damage: bool = false
var is_roaming: bool = true
var damage_to_deal = 20
var is_dealing_damage: bool = false

var corpse : bool = false
var player_in_carve_zone : bool = false

var playerdead : bool

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	
	if !is_on_floor():
		#y is gravity, drags him down. x will prevent him from moving side to side in air
		velocity.y += gravity * delta
		velocity.x += 0
	
	#updates the global script with the frogs damage and damagezone	
	Global.frog_DamageAmount = damage_to_deal
	Global.frog_DamageZone = $FrogDealDamageArea
		
	move(delta)
	handle_animation()
	
	#keeps checking the global for playerdead/alive 
	Global.playerAlive = playerdead
	if playerdead:
		is_frog_chase = false
	
	#checks if player is in the carve zone and if the frog is a corpse
	#if yes allows the carve prompt to register and then destroys itself
	#TODO needs filling out with carving animation and loot
	if player_in_carve_zone and corpse:
		print("waiting for input")
		if Input.is_action_just_pressed("interact"):
			print("carved frog")
			corpse = false
			self.queue_free()

	
#first updates its version of what "player" is with whats in the global
#makes sure its not dead. checks that its not taking damage and currently in chase, then finds player pos and directs itself towards
#checks if taking damage then applies knockback, takes direction of player and pushes itself away
#checks for not being in chase mode, takes dir(the random direction generator made below) 
#dead just checks for being dead, y drags it towards ground
func move(delta):
	player = Global.playerBody
	if !dead:
		if !taking_damage and is_frog_chase:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x
			dir.x = (abs(velocity.x)/ velocity.x)
		if taking_damage:
			var knockback_dir = position.direction_to(player.position) * -50
			velocity = knockback_dir
		if !is_frog_chase:
			is_roaming = true
			velocity += dir * speed * delta
	elif dead:
		velocity.y += 10 * delta
		velocity.x = 0
	move_and_slide()
	

#
func handle_animation():
	if !dead and !taking_damage and !is_dealing_damage:
		animated_sprite.play("hop")
		if dir.x == -1:
			animated_sprite.flip_h = true
		elif dir.x == 1:
			animated_sprite.flip_h = false
	elif !dead and taking_damage and !is_dealing_damage:
		animated_sprite.play("hurt")
		await get_tree().create_timer(0.8).timeout#adjust the number in the purse to the length of the animation
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		animated_sprite.play("dead")
		await get_tree().create_timer(1.0).timeout 
		handle_death()
		#these are completely uneeded here but I left them for you, future Lance to repurpose at your lesiure
		#this turns off collision layers so when dying an enemy can pass through certain collisions.
		#could be good for ignoring player collision after death, for cutting up corpse innit
		#set_collision_layer_value(1, false)
		#set_collision_mask_value(1, false)
	elif !dead and is_dealing_damage:
		animated_sprite.play("attack")
		
		
func handle_death():
	corpse = true
	handle_corpse()
	
		

##checks the global script if the thing entering the hitbox is the player's damagezone.
#makes a var that damage here is the same as the global player damage amount then links to take_damage function
func _on_hitbox_area_entered(area):
	if area == Global.playerDamageZone:
		var damage = Global.playerDamageAmount
		take_damage(damage)

##takes damage. already told it that damage = the playerdamageamount in the global script which updates on user input
#also makes it dead if health <= 0
func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true
	print(str(self), "current health is", health)
	

#asks the choose function nicely to pick a random number from its purse ()
func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([3.0, 2.0, 2.5])
	if !is_frog_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0
		print(dir)
		
##some kind on random number picker.
func choose(array):
	array.shuffle()
	return array.front()
	
	#signal from the frog's damage zone, if the area it touches is the same as the global player hitbox, ticks the dealing damage box
func _on_frog_deal_damage_area_area_entered(area: Area2D) -> void:
	if area == Global.playerHitbox:
		is_dealing_damage = true
		await get_tree().create_timer(1.0).timeout
		is_dealing_damage = false
		
func handle_corpse():
	print("hande corpse has been called")
	$FrogDealDamageArea/CollisionShape2D.disabled = true
	$hitbox/CollisionShape2D.disabled = true
	$CarveZone/CollisionShape2D.disabled = false

func _on_animated_sprite_2d_animation_finished():
	if (animated_sprite.animation == "dead"):
		animated_sprite.play("corpse")
		
func _on_carve_zone_body_entered(body) :
	if body.has_method("player"):
		player_in_carve_zone = true	
		print("player in carve zone true")

func _on_carve_zone_body_exited(body) :
	if body.has_method("player"):
		player_in_carve_zone = false
