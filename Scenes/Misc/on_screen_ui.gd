extends CanvasLayer
@onready var health_bar: ProgressBar = $HealthBar
@onready var damage_bar: ProgressBar = %DamageBar
@onready var damage_bar_timer: Timer = %DamageBarTimer


func _ready() -> void:
	health_bar.value = Global.current_health
	health_bar.max_value = Global.max_health
	
	damage_bar.value = Global.current_health
	damage_bar.max_value = Global.max_health
	
func _process(_delta: float) -> void:
	
	health_bar.max_value = Global.max_health
	damage_bar.max_value = Global.max_health
	health_bar.value = Global.current_health
	if Global.just_took_dam:
		damage_bar.value = Global.current_health + 10
	else:
		damage_bar.value = Global.current_health
	
	
	
func update_health():
	pass
	


func _on_damage_bar_timer_timeout() -> void:
	print("damagebar timeout (timer)")
	damage_bar.value = Global.current_health
