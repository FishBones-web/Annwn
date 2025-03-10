extends CharacterBody2D
class_name test_enemy

@export var enemy_stats : EnemyStats
@onready var marker_2d: Marker2D = $Marker2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hungry_timer: Timer = $Hungry_timer

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



func _ready() -> void:
	blackboard = bt_player.blackboard
	blackboard.bind_var_to_property(hunger_meter_var, self, "hungry_var")
	blackboard.bind_var_to_property(hunger_meter_float, self, "hunger_meter_var_no")

func _physics_process(_delta: float) -> void:
	if is_on_wall() && is_on_floor():
		velocity.y = enemy_stats.jump_power
	else:
		velocity.y += enemy_stats.gravity
		
	hunger_meter()
	move_and_slide()

func move(dir, speed):
	velocity.x = dir * speed
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
