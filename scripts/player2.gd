extends KinematicBody

var back_coll : bool = false
var left_coll : bool = false
var right_coll : bool = false
var coll : bool = false
var body : KinematicBody = null

func _ready():
	for i in  get_children():
		if i is Area:
			i.connect("body_entered", self, "_is_legal", [i.name])
			i.connect("body_exited", self, "_is_legal", [i.name])

# checks if pull action is being held
var _pull : bool = false
func _physics_process(_delta):
	if Input.is_action_pressed("pull_block"):
		_pull = true
	else:
		_pull = false


func _is_legal(_body, _area_name):
	if _body == null or _body.name == "player":
		return
	elif _body.name.substr(1,5) == "block" or _body.name == "wallbody":
		if _body.is_in_group("immobile"):
			back_coll = false
			left_coll = false
			right_coll = false
			coll = false
			return
		match _area_name:
			"front":
				coll = !coll
				body = _body
			"right":
				right_coll = !right_coll
				body = _body
			"left":
				left_coll = !left_coll
				body = _body
			"back":
				back_coll = !back_coll
			"inside":
				print("BUG")


func _input(_event):
	if _event.is_action_pressed("ui_up"):
		move_and_collide(Vector3(2,0.0, 0.0))
		translation = g_tetris._round(translation)
	
	if _event.is_action_pressed("ui_down"):
		move_and_collide(Vector3(-2,0.0, 0.0))
		translation = g_tetris._round(translation)
	
	if _event.is_action_pressed("ui_left"):
		if right_coll and !body.is_in_group("immobile") and _pull:
			move_and_collide(Vector3(0.0, 0.0, -2.0))
			yield(get_tree(), "idle_frame")
			yield(get_tree(), "idle_frame")
			body.move_and_collide(Vector3(0.0, 0.0, -2.0))
			return
		
		if left_coll and body.is_in_group("immobile"):
			return
		elif left_coll and !body.is_in_group("immobile"):
			move_and_collide(Vector3(0.0, 0.0,-2))
			body.move_and_collide(Vector3(0.0, 0.0,-2))
		else:
			move_and_collide(Vector3(0.0, 0.0,-2))
		translation = g_tetris._round(translation)
	
	if _event.is_action_pressed("ui_right"):
		if left_coll and !body.is_in_group("immobile") and _pull:
			move_and_collide(Vector3(0.0, 0.0, 2.0))
			yield(get_tree(), "idle_frame")
			yield(get_tree(), "idle_frame")
			body.move_and_collide(Vector3(0.0, 0.0, 2.0))
			return
		
		if right_coll and body.is_in_group("immobile"):
			return
		elif right_coll and !body.is_in_group("immobile"):
			move_and_collide(Vector3(0.0, 0.0,2))
			body.move_and_collide(Vector3(0.0, 0.0,2))
		else:
			move_and_collide(Vector3(0.0, 0.0,2))
		translation = g_tetris._round(translation)
	
	# quality of life
	if _event.is_action_pressed("ui_select") and (get_tree().get_nodes_in_group("blocks").size() > 1):
		get_tree().get_nodes_in_group("blocks").front().move_and_collide(Vector3(-40.0, 0.0, 0.0))
	if _event.is_action_pressed("rotate_right"):
		get_tree().get_nodes_in_group("blocks").back().rotate_y(-PI/2)
	if _event.is_action_pressed("rotate_left"):
		get_tree().get_nodes_in_group("blocks").back().rotate_y(PI/2)
