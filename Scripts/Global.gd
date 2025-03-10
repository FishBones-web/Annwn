extends Node

var current_scene = null
var next_scene = null
var transition_scene = false
var last_scene = null

var fresh_save = true
var hall_spikes = true
var cauldron_room_spikes = true

##teleport locs:
var game_start_posx = 3361
var game_start_posy = 3394

var player_enter_cauldronroom_posx = 508.0
var player_enter_cauldronroom_posy = 654.0
var player_exit_cauldronroom_posx = 6741.0
var player_exit_cauldronroom_posy = 3305.0

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(-1)
	
func preload_scene(path):
	ResourceLoader.load_threaded_request(path)
	
func goto_scene(path):
	# not safe to raw load a new scene, shit needs to be deferred to make sure everythings stopped
	_deferred_goto_scene.call_deferred(path)

func _deferred_goto_scene(path):
	#safe to remove the current scene.
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)
