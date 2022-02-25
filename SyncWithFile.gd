extends CheckBox


func _on_SyncWithFile_pressed():
	var settPathFile = File.new()
	settPathFile.open(Global.settingsPath, settPathFile.WRITE)
	settPathFile.store_line(to_json([Global.path, self.pressed]))
	settPathFile.close()
