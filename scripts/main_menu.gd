extends Node



func _on_Play_pressed():
	print("Hello")
	Transition.fade_to("res://scenes/game.tscn")
