extends Control

class_name T1_Button

var count = 0
var target = false
export(String) var display_name
export(String) var mod_name
export(Texture) var icon_texture
export(Array, Texture) var recipe_icon_textures
export(Array, NodePath) var recipe_names = get_nodes(recipe_names)
export(Array, String) var rewards 
export(String) var monster_power
export(String) var description
export(String) var recipe_search_string
 
var main_icon = true
var main_node = self

var sub_icon = load("res://Buttons/T0_Button.tscn")

var missing_components = {}
var depending_on = {}

func _ready():
	get_node("/root/Node2D").connect("ready", self, "add_sub_icons")
	Global.connect("inventory_changed", self, "check_for_missing")
	add_up_recipe_cost(self, depending_on)

func get_nodes(nodepaths):
	if nodepaths == null: return
	var nodes = []
	for path in nodepaths:
		nodes.append(get_node(path))
	return nodes


func add_sub_icons():
	var i = 0
	for each in recipe_icon_textures:
		var recipe_name = recipe_names[i]
		var mod = get_tree().root.get_node("Node2D/"+recipe_name)
		var icon = sub_icon.instance()
		icon.icon_texture = each
		icon.display_name = mod.display_name
		icon.mod_name = mod.mod_name
		icon.setup()
		icon.main_icon = false
		icon.main_node = mod
		$VBoxContainer.add_child(icon)
		i += 1
	$Name.text = display_name
	$TextureButton.texture_normal = icon_texture
	if Global.inventory.has(mod_name):
		count = int(Global.inventory[mod_name])
	else:
		Global.inventory[mod_name] = 0
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
	Global.emit_signal("inventory_changed", main_node)
	Global.update_buttons()

func _on_TextureButton_right():
	change_count(-1)
	Global.save_data()
	Global.emit_signal("inventory_changed", main_node)
	Global.update_buttons()
	
func _on_TextureButton_middle():
	var tracked = toggle_tracked()
	Global.save_data()
	get_tree().call_group("Button", "toggle_visability")
	if tracked:
		add_to_tracked_cost()
	else:
		remove_from_tracked_cost()
	Global.update_buttons()
	
func toggle_visability():
	if count == 0:
		$TextureButton.self_modulate = Color(0.2, 0.2, 0.2)
	else:
		$TextureButton.self_modulate = Color(1,1,1)
	var tracked = main_node.get_path() in Global.inventory["tracked"]
	$Tracked.visible = tracked

func toggle_tracked():
	var nodePath = main_node.get_path()
	var tracked = not nodePath in Global.inventory["tracked"]
	if tracked:
		Global.inventory["tracked"].append(nodePath)
	else:
		Global.inventory["tracked"].erase(nodePath)
	print("Tracked ",Global.inventory["tracked"])
	return tracked

func change_count(amount):
	count = max(count + amount, 0)
	main_node.count = count
	if not $TrackedPart.visible:
		$Counter.text = str(count)
	Global.inventory[mod_name] = count
	if count == 0:
		pass
	toggle_visability()
	
func update_count():
	count = Global.inventory[mod_name]
	if not $TrackedPart.visible:
		$Counter.text = str(count)
	toggle_visability()

func glow_toggle(b_name):
	if mod_name == b_name:
		$Glow.visible = !$Glow.visible
		

func _on_TextureButton_mouse_entered():
	Global.glow(mod_name)
	get_tree().call_group("Info", "show_info", mod_name)
	Global.current = mod_name
	toggle_missing()
	change_tracked_color(true)

func _on_TextureButton_mouse_exited():
	Global.glow(mod_name)
	get_tree().call_group("Info", "hide_info")
	Global.current = ""
	toggle_missing()
	change_tracked_color(false)

func search_glow(search_text):
	if search_text.to_lower() in mod_name.to_lower():
		$Search_Glow.visible = true
	else:
		$Search_Glow.visible = false
	for each in rewards:
		if search_text.to_lower() in each.to_lower():
			$Search_Glow.visible = true

func check_recipe():
	for each in recipe_names:
		var mod = get_node("/root/Node2D/"+each)
		if Global.inventory[mod.mod_name] == 0:
			highlight_craftable()
			return false
	recipe_glow(Color(1,5,5))
	return true

func _on_Button_pressed():
	OS.set_clipboard(recipe_search_string)

func _on_TextureButton_shift_click():
	if !check_recipe():
		print("Should not do it")
	else:
		change_count(1)
		for each in recipe_names:
			var mod = get_node("/root/Node2D/"+each)
			Global.inventory[mod.mod_name] = Global.inventory[mod.mod_name] -1
		Global.save_data()
		Global.update_buttons()

func recipe_glow(color):
	$"2mods/Sprite".self_modulate = color
	$"3mods/Sprite".self_modulate = color
	$"4mods/Sprite".self_modulate = color

func highlight_craftable():
	var complete = true
	for node in missing_components:
		if node is T0_Button:
			complete = false
	if complete:
		recipe_glow(Color(1,3,1))
	else:
		recipe_glow(Color(1,1,1))

var toggle = false
func toggle_missing():
	toggle = not toggle
	for node in depending_on:
		var glow = node.get_node("Missing_Glow")
		if node in missing_components:
			glow.visible = toggle
		var counter = node.get_node("Counter") as Label
		if toggle:
			counter.text = str(node.count) + "/" + str(depending_on[node])
		else:
			counter.text = str(node.count)
			if node in Global.trackedTotalMissing:
				if Global.trackedTotalMissing[node] > 0:
					counter.text += "/" + str(Global.trackedTotalMissing[node]+node.count)

func check_for_missing(changed_node):
	if changed_node != Global and not changed_node in depending_on: return
	var total_cost = depending_on.duplicate(true)
	for node in total_cost:
		var amount = min(depending_on[node], node.count)
		total_cost[node] -= amount
		if amount > 0:
			if not node is T0_Button:
				remove_sub_parts(node, total_cost, amount)
	
	missing_components = {}
	for node in total_cost:
		if total_cost[node] > 0:
			missing_components[node] = total_cost[node]
	
	highlight_craftable()

func remove_sub_parts(node, dict, amount):
	for nodePath in node.recipe_names:
		var recipePart = get_node("/root/Node2D/"+nodePath)
		if recipePart in dict:
			dict[recipePart] -= amount
		if not recipePart is T0_Button:
			remove_sub_parts(recipePart, dict, amount)

func add_up_recipe_cost(node, dict):
	if node is T0_Button: return
	
	var mod = node as T1_Button
	for nodepath in mod.recipe_names:
		var recipePart = get_node("/root/Node2D/"+nodepath)
		if recipePart in dict:
			dict[recipePart] += 1
		else:
			dict[recipePart] = 1
		add_up_recipe_cost(recipePart, dict)
		
func add_to_tracked_cost():
	if not main_node.get_path() in Global.inventory["tracked"]: return
	var dict = Global.trackedTotalCost
	add_up_recipe_cost(main_node, dict)

func remove_from_tracked_cost():
	if main_node.get_path() in Global.inventory["tracked"]: return
	var dict = Global.trackedTotalCost
	for mod in main_node.depending_on:
		dict[mod] -= main_node.depending_on[mod]
		if dict[mod] <= 0:
			dict.erase(mod)

func change_tracked_color(adapt):
	for node in main_node.depending_on:
		var color = Color(1,1,1)
		if adapt:
			var amounts = node.get_node("Counter").text.split("/")
			if len(amounts) == 2: 
				if amounts[0] >= amounts[1]:
					color = Color(0,1,0,10)
				else:
					color = Color(1,0,0,5)
		node.get_node("TrackedPart").modulate = color
	toggle_parts()

func toggle_parts():
	for node in main_node.depending_on:
		var frame = node.get_node("IsPartOf")
		frame.visible = not frame.visible
