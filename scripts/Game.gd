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
	
	get_node("SpawnTime").set_wait_time(2)
	get_node("SpawnTime").start()


func _on_SpawnTime_timeout():
	revive()


func revive():
	_character.position = get_node("SpawnPoint").position
	_character.revive()


func _on_Character_end():
	change_camera()
	
	get_node("SpawnTime").set_wait_time(3)
	get_node("SpawnTime").start()
