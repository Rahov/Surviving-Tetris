extends Spatial

signal score(_var)

var _points : int = 0
var rows : Array = []


func _ready():
	get_parent().connect("stopped", self, "_on_block_stopped")
	for i in get_children():
		rows.append(i)

## do the scoring
func _on_block_stopped():
	for j in rows:
		if j.get_overlapping_areas().size() > 9:
			_points += 1
			for i in j.get_overlapping_areas():
				i.queue_free()
				i.get_parent().get_node("CollisionShape" + i.name.substr(4,5)).queue_free()
			yield(get_tree(), "idle_frame")
			for i in get_tree().get_nodes_in_group("immobile"):
				if i.name != "wallbody":
					yield(get_tree(), "idle_frame")
					i.move_and_collide(Vector3(-2.0, 0.0, 0.0))
	if _points > 0:
		g_tetris.set_score(_points)
	
