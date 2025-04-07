extends CharacterBody2D
class_name test_enemy

@export var enemy_stats : Stats
@export var marker_2d: Marker2D
@export var animation_player: AnimationPlayer
@export var hungry_timer: Timer
@export var damage_cooldown : Timer

@export var bt_player: BTPlayer
var blackboard : Blackboard

##hunger vars for blackboard
static var hunger_meter_var : StringName = "hungry"
static var hunger_meter_float : StringName = "hunger_meter_var_float"

##hunger vars
@export var hungry_var : bool = false
@export var hunger_meter_var_no : float = 100
@export var hunger_meter_max : float = 100
@export var hunger_meter_min : float = 0

##combat
@export var can_take_dam : bool = true

func enemy():
	pass
	
func _ready() -> void:
	blackboard = bt_player.blackboard
	blackboard.bind_var_to_property(hunger_meter_var, self, "hungry_var")
	blackboard.bind_var_to_property(hunger_meter_float, self, "hunger_meter_var_no")

func _physics_process(_delta: float) -> void:
	if is_on_wall() && is_on_floor():
		velocity.y = enemy_stats.jump_power
	else:
		velocity.y += enemy_stats.gravity
		
		
	#hunger_meter()
	move_and_slide()
	handle_damage()
	handle_health()

func move(dir, speed):
	if enemy_stats.just_took_dam:
		pass
	else:
		velocity.x = dir * speed
		enemy_stats.last_moved_dir = dir
		handle_animation()
		update_flip(dir)
	
func handle_animation():
	if !is_on_floor():
		animation_player.play("fall")
	
	if velocity.x !=0:
		animation_player.play("move")
	else:
		animation_player.play("idle")
		
func update_flip(dir):
	if abs(dir) == dir:
		marker_2d.scale.x = 1
	else:
		marker_2d.scale.x = -1
		
func check_for_self(node):
	if node == self:
		return true
	else:
		return false

func hunger_meter():
	hungry_var = blackboard.get_var("hungry")
	hunger_meter_var_no = blackboard.get_var("hunger_meter_var_float")

	if hunger_meter_var_no <= 40:
		hungry_var = true
	elif hunger_meter_var_no >= 40:
		hungry_var = false
		
	if hunger_meter_var_no <= hunger_meter_min:
		hunger_meter_var_no = hunger_meter_min


func _on_hungry_timer_timeout() -> void:
	hunger_meter_var_no = hunger_meter_var_no - 5

func handle_health():
	if enemy_stats.current_health <= 1 :
		self.queue_free()
		
func handle_damage():
	if enemy_stats.just_took_dam and can_take_dam:
		can_take_dam = false
		velocity.x = enemy_stats.knockback_dir.x * enemy_stats.knockback_x
		velocity.y = enemy_stats.knockback_y
		if enemy_stats.bashed:
			await get_tree().create_timer(0.22).timeout
		else:
			await get_tree().create_timer(0.12).timeout
		print("knockback timeout")
		enemy_stats.just_took_dam = false
		enemy_stats.bashed = false
		velocity.x = 0
		velocity.y = 0
		enemy_stats.knockback_x = 0
		enemy_stats.knockback_y = 0
		damage_cooldown.start()

func _on_damage_cooldown_timeout() -> void:
	can_take_dam = true
