extends Node

var path = "user://Arch_inventory.json"
var inventory = {}
var current = ""

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
	var temp_file = File.new()
	if not temp_file.file_exists(path):
		temp_file.open(path, temp_file.WRITE)
		temp_file.store_line(to_json(inventory))
	temp_file.close()
	load_data()

func load_data():
	var file = File.new()
	file.open(path, file.READ)
	var text = file.get_as_text()
	inventory = parse_json(text)
	file.close()
	
func save_data():
	var file = File.new()
	file.open(path, file.WRITE)
	file.store_line(to_json(inventory))
	file.close()
	
func update_buttons():
	get_tree().call_group("Button", "update_count")

func glow(b_name):
	get_tree().call_group("Button", "glow_toggle", b_name)
	
