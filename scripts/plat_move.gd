extends KinematicBody2D


# 1 is right, -1 is left
var direction = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# delta is time between frames
func _physics_process(delta):
	var new_offset = get_parent().get_unit_offset() + delta*direction*0.2
	if direction == 1 and new_offset >= 0.99999:
		direction = -1
		get_parent().set_unit_offset(0.9999)
	elif direction == -1 and new_offset <= 0:
		direction = 1
		get_parent().set_unit_offset(0)
	else:
		get_parent().set_unit_offset(new_offset)
