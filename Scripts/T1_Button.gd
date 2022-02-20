extends Control

var count = 0
var target = false
export(String) var icon_name
export(Texture) var icon_texture
export(Array, Texture) var recipe_icon_textures
export(Array, String) var recipe_names
export(Array, String) var rewards
export(String) var monster_power
export(String) var description
export(String) var recipe_search_string
 
var main_icon = true

var sub_icon = load("res://Buttons/T0_Button.tscn")

func _ready():
	var i = 0
	for each in recipe_icon_textures:
		var icon = sub_icon.instance()
		icon.icon_texture = each
		icon.icon_name = recipe_names[i]
		icon.setup()
		icon.main_icon = false
		$VBoxContainer.add_child(icon)
		i += 1
	$Name.text = icon_name
	$TextureButton.texture_normal = icon_texture
	if Global.inventory.has(icon_name):
		count = int(Global.inventory[icon_name])
	else:
		Global.inventory[icon_name] = 0
	change_count(0)
	toggle_visability()
	if recipe_names.size() == 2:
		$"2mods".visible = true
	if recipe_names.size() == 3:
		$"3mods".visible = true
	if recipe_names.size() == 4:
		$"4mods".visible = true
	
func _on_TextureButton_left():
	change_count(1)
	Global.save_data()
	Global.update_buttons()

func _on_TextureButton_right():
	change_count(-1)
	Global.save_data()
	Global.update_buttons()
	
func _on_TextureButton_middle():
	toggle_tracked()
	Global.save_data()
	get_tree().call_group("Button", "toggle_visability")

func toggle_visability():
	if count == 0:
		$TextureButton.self_modulate = Color(0.2, 0.2, 0.2)
	else:
		$TextureButton.self_modulate = Color(1,1,1)
	if icon_name in Global.inventory["tracked"]:
		$Tracked.visible = true
	else:
		$Tracked.visible = false

func toggle_tracked():
	if icon_name in Global.inventory["tracked"]:
		Global.inventory["tracked"].erase(icon_name)
	else:
		Global.inventory["tracked"].append(icon_name)
	print(Global.inventory["tracked"])

func change_count(amount):
	count = max(count + amount, 0)
	$Counter.text = str(count)
	Global.inventory[icon_name] = count
	if count == 0:
		pass
	toggle_visability()
	
func update_count():
	count = Global.inventory[icon_name]
	$Counter.text = str(count)
	toggle_visability()

func glow_toggle(b_name):
	if icon_name == b_name:
		$Glow.visible = !$Glow.visible
		

func _on_TextureButton_mouse_entered():
	Global.glow(icon_name)
	get_tree().call_group("Info", "show_info", icon_name)
	Global.current = icon_name

func _on_TextureButton_mouse_exited():
	Global.glow(icon_name)
	get_tree().call_group("Info", "hide_info")
	Global.current = ""

func search_glow(search_text):
	if search_text.to_lower() in icon_name.to_lower():
		$Search_Glow.visible = true
	else:
		$Search_Glow.visible = false
	for each in rewards:
		if search_text.to_lower() in each.to_lower():
			$Search_Glow.visible = true

func check_recipe():
	for each in recipe_names:
		if Global.inventory[each] == 0:
			recipe_glow(false)
			return false
	recipe_glow(true)
	return true
			
func _on_Button_pressed():
	OS.set_clipboard(recipe_search_string)

func _on_TextureButton_shift_click():
	if !check_recipe():
		print("Should not do it")
	else:
		change_count(1)
		for each in recipe_names:
			Global.inventory[each] = Global.inventory[each] -1
		Global.save_data()
		Global.update_buttons()

func recipe_glow(ok):
	if ok:
		$"2mods/Sprite".self_modulate = Color(1, 5,5)
		$"3mods/Sprite".self_modulate = Color(1, 5,5)
		$"4mods/Sprite".self_modulate = Color(1, 5,5)
	else:
		$"2mods/Sprite".self_modulate = Color(1, 1,1)
		$"3mods/Sprite".self_modulate = Color(1, 1,1)
		$"4mods/Sprite".self_modulate = Color(1, 1,1)
