extends Node


func _ready():
	for i in get_children():
		if i is Area:
			i.connect("area_entered", self, "_is_coll")


func _is_coll(_area : Area) -> void:
	if _area.name == "rotate" and get_tree().get_nodes_in_group("blocks").size() < 2:
		get_tree().get_root().get_node("main/Spawn").start()
		var _mat = SpatialMaterial.new()
		_mat.set_albedo(Color.gray)
		for i in get_children():
			if i is Area:
				i.get_child(0).set_surface_material(0, _mat)
		
