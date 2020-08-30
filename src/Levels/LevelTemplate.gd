extends Node2D

class_name LevelTemplate
onready var rng = RandomNumberGenerator.new()
onready var player := get_node("/root/Game/Player")
onready var coal_scene = preload("res://src/Objects/Coal.tscn")

func _ready() -> void:
	pass

func populate_coals(coal_rate: float) -> void:
	var cells = $TileMap.get_used_cells()
	for cell in cells:
		rng.randomize()
		if rng.randf() < coal_rate:
			spawn_coal(cell)

func spawn_coal(cell_position: Vector2) -> void:
	print(cell_position)
	var coal_position = cell_position * 16 + Vector2(10, -18)
#	if $TileMap.get_cellv(coal_position) < 0:
	var coal = coal_scene.instance()
	coal.position = coal_position
	add_child(coal)
	coal.connect("coal_collected", player, "on_coal_collected")
