extends Node

signal stopped

onready var prefix : Array = ["L", "J", "O", "I", "Z", "T", "S"]

var rng = RandomNumberGenerator.new()

func _ready():
	# warning-ignore:return_value_discarded
	$"Spawn".connect("timeout",self,"_spawn_timeout")
# warning-ignore:return_value_discarded
	$"Speed".connect("timeout",self,"_speed_timeout")
	## making sure the lkines group is empty
	$"block".remove_from_group("lines")
	$"block".remove_from_group("immobile")
	rng.randomize()


func make_block():
	yield(get_tree(), "idle_frame")
	var _placeholder : Resource = load("res://blocks/" + prefix[rng.randi_range(0,6)] + "_block.tscn")
	var _new = _placeholder.instance()
	_new.translation = Vector3(40,1,0)
	add_child(_new)


func _spawn_timeout():
	old = Vector3(40.0,0.0,0.0)
	make_block()


var old = Vector3(30.0,0.0,0.0)
func _speed_timeout():
	var _block  : KinematicBody = get_tree().get_nodes_in_group("blocks").front()
	var _player : KinematicBody = $"player"
	
	if _player.coll:
#		print("1: ", _player.translation)
		_player.move_and_collide(Vector3(-2,0,0))
		yield(get_tree(), "idle_frame")
		_player.body.move_and_collide(Vector3(-2,0,0))
		print(_player.back_coll)
	
	_block.move_and_collide(Vector3(-2.0, 0.0, 0.0))
	_block.translation = g_tetris._round(_block.translation)
	
#	print(_block.translation)
	if !(old.x - _block.translation.x):
#		$"Spawn".start()
		_block.remove_from_group("blocks")
		_block.add_to_group("immobile")
		emit_signal("stopped")
	old = _block.translation
