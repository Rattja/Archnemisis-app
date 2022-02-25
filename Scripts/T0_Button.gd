extends Control

class_name T0_Button

var count = 0
var target = false
export(String) var display_name
export(String) var mod_name
export(Texture) var icon_texture
export(Array, String) var rewards
export(String) var monster_power
export(String) var description
var main_icon = true
var main_node = self

func _ready():
	setup()

func setup():
	$Name.text = display_name
	$TextureButton.texture_normal = icon_texture
	if Global.inventory.has(mod_name):
		count = int(Global.inventory[mod_name])
	else:
		Global.inventory[mod_name] = 0
	change_count(0)
	toggle_visability()
	if Global.drop_hints.has(mod_name):
		var hint_text = "Likely to drop in: \n" + PoolStringArray(Global.drop_hints[mod_name]).join("\n")
		$TextureButton.hint_tooltip = hint_text
 
func _on_TextureButton_left():
	change_count(1)
	Global.save_data()
	Global.update_buttons()
	Global.emit_signal("inventory_changed", main_node)

func _on_TextureButton_right():
	change_count(-1)
	Global.save_data()
	Global.update_buttons()
	Global.emit_signal("inventory_changed", main_node)

func change_count(amount):
	count = max(count + amount, 0)
	main_node.count = count
	$Counter.text = str(count)
	Global.inventory[mod_name] = count
	toggle_visability()
	
	
func update_count():
	count = Global.inventory[mod_name]
	$Counter.text = str(count)
	toggle_visability()

func _on_TextureButton_mouse_entered():
	Global.glow(mod_name)
	get_tree().call_group("Info", "show_info", mod_name)
	Global.current = mod_name

func _on_TextureButton_mouse_exited():
	Global.glow(mod_name)
	get_tree().call_group("Info", "hide_info")
	Global.current = ""

###############################		Change Start 		######################################################################

func _on_TextureButton_middle():
	toggle_tracked()
	Global.save_data()
	get_tree().call_group("Button", "toggle_visability")

func toggle_visability():
	if count == 0:
		$TextureButton.self_modulate = Color(0.2, 0.2, 0.2)
	else:
		$TextureButton.self_modulate = Color(1,1,1)
	if mod_name in Global.inventory["tracked"]:
		$Tracked.visible = true
	else:
		$Tracked.visible = false

func toggle_tracked():
	if mod_name in Global.inventory["tracked"]:
		Global.inventory["tracked"].erase(mod_name)
	else:
		Global.inventory["tracked"].append(mod_name)


###############################		Change End 		######################################################################

func glow_toggle(b_name):
	if mod_name == b_name:
		$Glow.visible = !$Glow.visible

func search_glow(search_text):
	if search_text.to_lower() in mod_name.to_lower():
		$Search_Glow.visible = true
	else:
		$Search_Glow.visible = false
	for each in rewards:
		if search_text.to_lower() in each.to_lower():
			$Search_Glow.visible = true
