extends HBoxContainer

var coal_img = preload("res://assets/coal.png")

onready var player := get_node("/root/Game/Player")

func _ready() -> void:
	player.connect("coal_count_changed", self, "update_coal_bar")

func update_coal_bar(coal_count) -> void:
	for i in get_child_count():
		get_child(i).visible = coal_count > i
