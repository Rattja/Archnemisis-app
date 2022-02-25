extends NinePatchRect

var reward_icon = load("res://RewardIcon.tscn")

func _ready():
	hide_info()


func show_info(icon_name):
	var reward_text = []
	var monster_power = ""
	var rewards = []
	var other_reward = ""
	
	for each in get_tree().get_nodes_in_group("Button"):
		if each.main_icon and each.mod_name == icon_name:
			monster_power = each.monster_power
			rewards = each.rewards
			other_reward = each.description
	
	for each in rewards:
		var x = reward_icon.instance()
		var texture_path = "res://Icons/"+each+ ".png"
		reward_text.append(each)
		x.set_texture(texture_path) 
		$RewardIcons.add_child(x)
	visible = true
	$RewardText.text = PoolStringArray(reward_text).join(", ")
	$Powers.text = monster_power
	$OtherReward.text = other_reward
	
func hide_info():
	visible = false
	for each in $RewardIcons.get_children():
		each.queue_free()
