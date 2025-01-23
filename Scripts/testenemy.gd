# to fix: The frog picks up velocity the more it moves in one direction, making it speed up
# but also slide as it turns in a new direction :(
#If the frog is chasing the player and they jump, he gains y.dir, floating in the air to follow them
#The frog refuses to accept gravity
extends CharacterBody2D

class_name FrogEnemy
const speed = 10
var dir: Vector2
var is_frog_chase: bool
var player: CharacterBody2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var gravity = 900

var health = 50
var health_max = 50
var health_min = 0
var dead: bool = false
var taking_damage: bool = false
var is_roaming: bool = true
var damage_to_deal = 20
var is_dealing_damage: bool = false
var knockback_force = 200

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	
	if !is_on_floor():
		#y is gravity, drags him down. x will prevent him from moving side to side in air
		velocity.y += gravity * delta
		velocity.x += 0
		
	move(delta)
	handle_animation()
	
	if is_on_floor() and dead:
		await get_tree().create_timer(3.0).timeout # timer needs changing. too long
		self.queue_free()

	
	
	
func move(delta):
	player = Global.playerBody
	if !dead:
		if !taking_damage and is_frog_chase:
			velocity = position.direction_to(player.position) * speed
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
	


func handle_animation():
	if !dead and !taking_damage:
		animated_sprite.play("hop")
		if dir.x == -1:
			animated_sprite.flip_h = true
		if dir.x == 1:
			animated_sprite.flip_h = false
	elif !dead and taking_damage:
		animated_sprite.play("hurt")
		await get_tree().create_timer(0.8).timeout#adjust the number in the purse to the length of the animation
		taking_damage = false
	elif dead:
		is_roaming = false
		animated_sprite.play("dead")
		#these are completely uneeded here but I left them for you, future Lance to repurpose at your lesiure
		#this turns off collision layers so when dying an enemy can pass through certain collisions.
		#could be good for ignoring player collision after death, for cutting up corpse innit
		#set_collision_layer_value(1, false)
		#set_collision_mask_value(1, false)
		
		
		
		

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
	
