extends TextureButton

signal right
signal left
signal middle

func _ready():
	pass # Replace with function body.

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action_released("Mouse_left"):
			emit_signal("left")
		if event.is_action_released("Mouse_right"):
			emit_signal("right")
		if event.is_action_released("Mouse_middle"):
			emit_signal("middle")
