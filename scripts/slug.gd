extends KinematicBody2D


# 1 is right, -1 is left
var direction = -1
var alive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# delta is time between frames
func _physics_process(delta):
	var new_offset = get_parent().get_unit_offset() + delta*direction*0.3
	if direction == 1 and new_offset >= 0.99999:
		direction = -1
		get_parent().set_unit_offset(0.9999)
		get_node("Sprite").set_flip_h(false)
	elif direction == -1 and new_offset <= 0:
		direction = 1
		get_parent().set_unit_offset(0)
		get_node("Sprite").set_flip_h(true)
	else:
		get_parent().set_unit_offset(new_offset)

func crush():
	if not alive: return
	alive = false
	get_node("Anim").stop()
	get_node("Sprite").set_texture(load("res://assets/enemy/slimeDead.png"))
	get_node("Sprite").set_offset(Vector2(0, 8))
	get_node("Shape").queue_free()
	set_physics_process(false)
