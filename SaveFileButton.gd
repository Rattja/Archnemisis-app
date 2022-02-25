extends Button
var dialog = null

func _ready():
	dialog = get_child(0)
	
func _on_Button_pressed():
	dialog = get_child(0)
	dialog.popup_centered()
	self.disabled = true



func _on_FileDialog_file_selected(path):
	dialog.hide()
	self.disabled = false
	Global.path = path
	Global.load_data()
	Global.update_buttons()
	Global.save_data()




func _on_FileDialog_modal_closed():
	self.disabled = false
