extends LineEdit


func _ready():
	pass # Replace with function body.

func _on_LineEdit_text_changed(new_text):
	get_tree().call_group("Button", "search_glow", text)

func _input(event):
	if event.is_action_released("Search"):
		grab_focus()
