extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Coin_body_entered(body):
	body.coin()
	get_node("Anim").play("collect")
	get_node("Shape").queue_free()
	yield(get_node("Anim"), "animation_finished")
	queue_free()
