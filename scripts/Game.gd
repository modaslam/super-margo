extends Node


onready var _character = get_node("Character")
onready var _camera = get_node("DeadCamera")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func change_camera():
	_camera.set_global_position(_character.get_node("Camera").get_camera_position())
	_camera.make_current()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Character_died():
	change_camera()
