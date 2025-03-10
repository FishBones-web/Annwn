extends Node
class_name Camera_Manager
@export var player : CharacterBody2D
@export var Camera_Zone0 : PhantomCamera2D
@export var Camera_Zone1 : PhantomCamera2D
@export var Camera_Zone2: PhantomCamera2D
@export var Camera_Zone3: PhantomCamera2D

@export var current_camera_zone: int = 0

##updated by barriers triggered, is fed the body, and what zones are either side
#takes whatever zone is current and swaps it to the other zone
func update_current_zone(body, zone):
	if body.has_method("player"):
		current_camera_zone = zone
		update_camera()

func update_camera():
	print("camera zone:", current_camera_zone)
	var cameras = [Camera_Zone0, Camera_Zone1, Camera_Zone2, Camera_Zone3]
	for camera in cameras:
		if camera != null:
			camera.priority = 0
			
	match current_camera_zone:
		0:
			Camera_Zone0.priority = 1
		1:
			Camera_Zone1.priority = 1
		2:
			Camera_Zone2.priority = 1
		3:
			Camera_Zone3.priority = 1
	
			
	
##triggered by the collision barrier, updates the zone toggle with: the body going through, which zones are either side
##to add more zones repeat this, create new area2ds with coll and signal, (body, 1,2) ect
func _on_zone_01_body_entered(body) -> void:
	update_current_zone(body, 0)

func _on_zone_1_body_entered(body) -> void:
	update_current_zone(body, 1)

func _on_zone_2_body_entered(body) -> void:
	update_current_zone(body, 2)

func _on_zone_3_body_entered(body) -> void:
	update_current_zone(body, 3)
