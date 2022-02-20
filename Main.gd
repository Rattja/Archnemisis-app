extends Node2D
# Test text for github testtest 

func _ready():
	get_tree().call_group("T1", "check_recipe")

func _input(event):
	if event.is_action_released("Copy_current"):
		OS.set_clipboard(Global.current)
