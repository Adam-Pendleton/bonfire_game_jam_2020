extends Node2D

onready var rng := RandomNumberGenerator.new()
var templates_count = 2

func _ready() -> void:
	var position: Vector2 = $Player.position
	for i in range(1, 10):
		generate_level_chunk(position)
		#TODO: each chunk should be able to have its own height, so move the position based on the height of the last chunk
		position.y -= 120
		
	#TODO: generate new chunks as the player reaches further up
	#also, remove old chunks to keep from accumulating too many children
	
func _process(delta) -> void:
	pass

func generate_level_chunk(position: Vector2) -> void:
	var template = get_level_template_scene()
	var chunk = template.instance()
	add_child(chunk)
	chunk.position = position
	
func get_level_template_scene() -> Resource:
	rng.randomize()
	var random_number = rng.randi_range(1, templates_count)
	var level_path = "res://src/Levels/LevelTemplate%s.tscn"
	level_path = level_path % random_number
	var level_chunk: Resource = load(level_path)
	return level_chunk
