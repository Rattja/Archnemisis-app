extends Node

var path = "user://Arch_inventory.json"
var settingsPath = "user://settings.json"
var inventory = {}
var current = ""
var syncButton
var syncButtonPressed

signal inventory_changed(changed_node)

var trackedTotalCost = {}
var trackedTotalMissing = {}

var drop_hints = {
'Arcane Buffer': ['Armoury','Dry Sea','Glacier','Grave Through','Mineral Pools','Peninsula','Precinct'],
'Berserker': ['Carcass','Coves','Forge of the Phoenix','Glacier','Grave Through','Graveyard','Laboratory','Estuary','Pit of the Chimaera'],
'Bloodletter': ['Coves','Dry Sea','Forbidden Woods','Plaza'],
'Bombardier': ['Bramble Valley','Burial Chamber','Coral Ruins','Coves','Fields','Frozen Cabins','Graveyard','Ivory Temple','Maze','Peninsula','Strand','Vaal Temple','Gardens'],
'Bonebreaker': ['Armoury','Cells','City Square','Port','Promenade'],
'Chaosweaver': ['Carcass','Cells','Forge of the Phoenix','Marshes','Maze'],
'Consecrator': ['Arcade','Iceberg','Maze','Strand','Colosseum'],
'Deadeye': ['Belfry','Caldera','Coves','Fields','Infested Valley','Laboratory','Phantasmaggoria','Plaza','Port','Summit','Colosseum'],
'Dynamo': ['Coves','Dig','Dunes','Fields','Iceberg','Plaza','Port','Colosseum'],
'Echoist': ['Dry Sea','Phantasmaggoria','Plaza','Promenade'],
'Flameweaver': ['Armoury','Belfry','Coral Ruins','Fields','Forge of the Phoenix','Frozen Cabins','Graveyard','Grotto','Orchard','Peninsula','Plaza','Port','Promenade','Stagnation','Uber lab'],
'Frenzied': ['Ashen Wood','Cage','Coral Ruins','Lair','Marshes','Temple'],
'Frostweaver': ['Cells','Cursed Crypt','Desert Spring','Dry Sea','Dungeon','Forge of the Phoenix','Haunted Mansion','Lair of the Hydra','Maze','Peninsula','Phantasmaggoria','Silo','Spider Forest','Summit','Overgrown Shrine','Toxic Sewer','Bone Crypt','Pit of the Chimaera'],
'Gargantuan': ['Ashen Wood','Cells','Coves','Cursed Crypt','Dunes','Fields','Iceberg','Maze of the Minotaur','Orchard','Strand','Temple','Underground River','Vaal Pyramid','Gardens'],
'Hasted': ['Atoll','Carcass','Cold river','Coral Ruins','Desert Spring','Dry Sea','Dunes','Forge of the Phoenix','Grave Through','Graveyard','Grotto','Lair','Maze of the Minotaur','Peninsula','Phantasmaggoria','Port','Promenade','Strand','Summit','Precint','Estuary'],
'Incendiary': ['Cage','Cells','Graveyard','Maze','Peninsula','Primordial Pool','Silo','Uber lab'],
'Juggernaut': ['Canyon','City Square','Coves','Crimson Temple','Dry Sea','Fields','Forge of the Phoenix','Graveyard','Phantasmaggoria','Primordial Pool','Strand','Uber lab','Vaal Pyramid','Precint','Overgrown Shrine'],
'Malediction': ['Atoll','Belfry','Canyon','Cells','Coves','Dry Sea','Fields','Forge of the Phoenix','Haunted Mansion','Lookout','Marshes','Port','Shipyard','Strand','Wasteland','Ghetto'],
'Overcharged': ['Ancient City','Crimson Temple','Defiled Cathedral','Dry Sea','Dungeon','Forbidden Woods','Frozen Cabins','Phantasmaggoria','Plaza','Summit','Underground River','Overgrown Shrine'],
'Permafrost': ['Dig','Fields','Graveyard','Lookout','Orchard','Plaza','Strand','Temple','Ghetto','Conservatory','Lava Chamber'],
'Sentinel': ['Armoury','Belfry','Cage','Coves','Dry Sea','Fields','Malformation','Promenade','Temple'],
'Soul Conduit': ['Ashen Wood','Caldera','Coves','Crimson Temple','Cursed Crypt','Forge of the Phoenix','Haunted Mansion','Laboratory','Marshes','Maze','Maze of the Minotaur','Peninsula','Plaza','Promenade','Spider Forest'],
'Steel-infused': ['Armoury','Beach','Burial Chamber','Cursed Crypt','Forbidden Woods','Glacier','Graveyard','Lair','Maze','Orchard','Plaza','Port','Promenade','Summit','Wasteland'],
'Stormweaver': ['Ashen Wood','Belfry','Bramble Valley','Caldera','Graveyard','Laboratory','Lair','Lookout','Port','Spider Forest','Summit','Temple','Uber lab','Conservatory','Toxic Sewer','Lava Chamber'],
'Toxic': ['Ancient City', 'Arsenal','Ashen Wood','Carcass','Coves','Defiled Cathedral','Forge of the Phoenix','Grave Through','Laboratory','Malformation','Orchard','Peninsula','Port','Shipyard','Pit of the Chimaera'],
'Vampiric': ['Arsenal', 'Coral Ruins','Grotto','Haunted Mansion','Iceberg','Lair of the Hydra','Marshes','Peninsula','Port','Primordial Pool','Uber lab','Underground River']

}


func _ready():
	var settPathFile = File.new()
	if not settPathFile.file_exists(settingsPath):
		settPathFile.open(settingsPath, settPathFile.WRITE)
		settPathFile.store_line(to_json([path, true]))
	else:
		settPathFile.open(settingsPath, settPathFile.READ)
		var settingText = settPathFile.get_as_text()
		var settings = parse_json(settingText)
		path = settings[0]
		syncButtonPressed = settings[1]
	settPathFile.close()
	var invFile = File.new()
	if not invFile.file_exists(path):
		invFile.open(path, invFile.WRITE)
		invFile.store_line(to_json(inventory))
	invFile.close()
	load_data()
	
	get_tree().call_group("Button", "add_to_tracked_cost")
	yield(get_tree().create_timer(1.0), "timeout") #god knows why this is necessary...
	update_buttons()

func load_data():
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	inventory = parse_json(text)
	if not "tracked"  in inventory.keys():
		inventory["tracked"] = []
	file.close()
	var tracked = inventory["tracked"]
	for i in range(len(tracked)):
		tracked[i] = NodePath(tracked[i])
	
func save_data():
	var file = File.new()
	file.open(path, file.WRITE)
	file.store_line(to_json(inventory))
	file.close()
	var settPathFile = File.new()
	settPathFile.open(settingsPath, settPathFile.WRITE)
	settPathFile.store_line(to_json([path, syncButton.pressed]))
	settPathFile.close()
	
func update_buttons():
	get_tree().call_group("Button", "update_count")
	get_tree().call_group("T1", "check_for_missing", Global)
	get_tree().call_group("T1", "highlight_missing")
	get_tree().call_group("T1", "check_recipe")
	update_tracked_cost()
	highlight_tracked_parts()

func glow(b_name):
	get_tree().call_group("Button", "glow_toggle", b_name)
	
	
func _notification(event):
	if event != NOTIFICATION_UNPARENTED and event != NOTIFICATION_PREDELETE:
		 if syncButton != null and not syncButton.pressed: return
	if event == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		load_data()
		update_buttons()

func update_tracked_cost():
	trackedTotalMissing = trackedTotalCost.duplicate(true)
	for nodePath in inventory["tracked"]:
		var node = get_node(nodePath)
		var amount = min(1, node.count)
		if amount > 0:
			if node is T1_Button:
				remove_sub_parts(node, trackedTotalMissing, amount)
			else:
				trackedTotalMissing[node] -= amount
	for node in trackedTotalMissing:
		var amount = min(trackedTotalMissing[node], node.count)
		if amount > 0:
			trackedTotalMissing[node] -= amount
			if node is T1_Button:
				remove_sub_parts(node, trackedTotalMissing, amount)
	var tempMissing = {}
	for node in trackedTotalMissing:
		if trackedTotalMissing[node] > 0:
			tempMissing[node] = trackedTotalMissing[node]
	trackedTotalMissing = tempMissing
	
func remove_sub_parts(target, dict, amount):
	for nodePath in target.recipe_names:
		var recipePart = get_node("/root/Node2D/"+nodePath)
		if recipePart in dict:
			dict[recipePart] = dict[recipePart] - amount
		if not recipePart is T0_Button:
			remove_sub_parts(recipePart, dict, amount)

func highlight_tracked_parts():
	var all_buttons = get_tree().get_nodes_in_group("Button")
	for mod in all_buttons:
		var part = mod.get_node("TrackedPart") as Line2D
		var label = mod.get_node("Counter") as Label
		if mod in trackedTotalMissing:
			part.visible = true
			label.text = str(mod.count) + "/" + str(trackedTotalMissing[mod])
		else:
			part.visible = false
			label.text = str(mod.count)
