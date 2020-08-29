extends HBoxContainer

var moneybag = preload("res://assets/images/objects/moneybag.png")
var moneybag_outline = preload("res://assets/images/objects/moneybag_outline.png")

onready var player := get_node("/root/Game/Player")

func _ready() -> void:
	player.connect("money_count_changed", self, "update_moneybag_bar")

func update_moneybag_bar(money_count) -> void:
	if money_count >= 16:
		get_node("/root/Game").complete_level()
	for i in get_child_count():
		if money_count > i:
			get_child(i).texture = moneybag
		else:
			get_child(i).texture = moneybag_outline
		
