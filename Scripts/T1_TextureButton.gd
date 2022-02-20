extends TextureButton

signal right
signal left
signal middle
signal shift_click

func _ready():
	pass # Replace with function body.

func _gui_input(event):
	if event is InputEventMouseButton:
		print(event)
		if event.is_action_released("Mouse_left"):
			if Input.is_action_pressed("Shift"):
				emit_signal("shift_click")
			else:
				emit_signal("left")
		if event.is_action_released("Mouse_right"):
			emit_signal("right")
		if event.is_action_released("Mouse_middle"):
			emit_signal("middle")
