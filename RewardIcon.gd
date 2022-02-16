extends Control


func _ready():
	pass # Replace with function body.

func set_texture(texture_path):
	var x = load(texture_path)
	$Sprite.texture = x
