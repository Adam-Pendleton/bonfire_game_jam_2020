extends Node2D

onready var rng := RandomNumberGenerator.new()
var templates_count = 2

func _ready() -> void:
	generate_level_chunk()
	
func _process(delta) -> void:
	pass

func generate_level_chunk() -> void:
	var template = get_level_template_scene()
	var chunk = template.instance()
	add_child(chunk)
	chunk.position = $Player.get_global_position()
	
func get_level_template_scene() -> Resource:
	rng.randomize()
	var random_number = rng.randi_range(1, templates_count)
	var level_path = "res://src/Levels/LevelTemplate%s.tscn"
	level_path = level_path % random_number
	var level_chunk: Resource = load(level_path)
	return level_chunk
