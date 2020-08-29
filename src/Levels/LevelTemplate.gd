extends Node2D

class_name LevelTemplate
onready var rng = RandomNumberGenerator.new()
onready var coal_scene = preload("res://src/Objects/Coal.tscn")

func _ready() -> void:
	pass

func populate_coals(coal_rate: float) -> void:
	var cells = $TileMap.get_used_cells()
	print(len(cells))
	for cell in cells:
		print(cell)
		rng.randomize()
		if rng.randf() < coal_rate:
			spawn_coal(cell)

func spawn_coal(cell_position: Vector2) -> void:
	var coal_position = cell_position * 32 + Vector2(16, -20)
	if $TileMap.get_cellv(coal_position) < 0:
		var coal = coal_scene.instance()
		coal.position = coal_position
		add_child(coal)

