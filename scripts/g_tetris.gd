extends Node

var g_score : float = 0.0 setget set_score
#var g_level : int = 0

# where _x is the number of lines
func set_score(_x):
	var x_3 : float = pow(_x, 3)
	var x_2 : float = pow(_x, 2)
	g_score = 280.0*x_3/3.0 - 490.0*x_2 + 2630.0*_x/3.0 - 440.0 # * (g_level + 1)
	print(g_score)
	g_score = round(g_score)
	print(g_score)
	get_tree().get_root().get_node("main/UI/Panel/RichTextLabel").text = "Score: "+ str(g_score)
	


func _round(_vak : Vector3) -> Vector3:
	_vak.x = round(_vak.x)
	_vak.y = round(_vak.y)
	_vak.z = round(_vak.z)
	return _vak
