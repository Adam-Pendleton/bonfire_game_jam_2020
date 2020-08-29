extends HBoxContainer

var coal = preload("res://assets/images/objects/coal.png")
var coal_outline = preload("res://assets/images/objects/coal_outline.png")

onready var player := get_node("/root/Game/Player")

func _ready() -> void:
	player.connect("coal_count_changed", self, "update_coal_bar")

func update_coal_bar(coal_count) -> void:
	for i in get_child_count():
		if coal_count > i:
			get_child(i).texture = coal
		else:
			get_child(i).texture = coal_outline
		
