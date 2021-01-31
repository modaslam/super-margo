extends Node


onready var _character = get_node("Character")
onready var _camera = get_node("DeadCamera")

var coins = 0
var lives = 3

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
	
	lives -= 1
	
	if lives == 2:
		get_node("CanvasLayer/Controls/Panel/Heart1").set_texture(load("res://assets/hud_heartEmpty.png"))
	elif lives == 1:
		get_node("CanvasLayer/Controls/Panel/Heart2").set_texture(load("res://assets/hud_heartEmpty.png"))
	elif lives == 0:
		get_node("CanvasLayer/Controls/Panel/Heart3").set_texture(load("res://assets/hud_heartEmpty.png"))


func _on_SpawnTime_timeout():
	if lives > 0:
		revive()
	else:
		Transition.fade_to("res://scenes/main_menu.tscn")


func revive():
	_character.position = get_node("SpawnPoint").position
	_character.revive()
	
	get_node("GameTime").set_wait_time(30)
	get_node("GameTime").start()


func _on_Character_end():
	change_camera()
	
	get_node("SpawnTime").set_wait_time(3)
	get_node("SpawnTime").start()


func _on_Character_coin():
	coins += 1
	get_node("CanvasLayer/Controls/Panel/Coins").set_text(str(coins))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_node("CanvasLayer/Controls/Panel/Time").set_text(str(int(get_node("GameTime").get_time_left())))
