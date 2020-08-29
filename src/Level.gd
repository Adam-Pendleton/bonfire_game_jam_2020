extends Node2D

onready var rng := RandomNumberGenerator.new()
onready var player := get_node("/root/Game/Player")
export var stage_forgetting_distance = 900
export var stage_spawn_distance = 600

var highest_stage = null
var templates_count = 3

func _ready() -> void:
	create_initial_level()
	
func create_initial_level() -> void:
	var spawn_position: Vector2 = player.position + Vector2(0, 40)
	highest_stage = generate_level_stage(spawn_position)
	spawn_position.y -= highest_stage.height
	while player.position.distance_to(highest_stage.position) < stage_spawn_distance:
		highest_stage = generate_level_stage(spawn_position)
		spawn_position.y -= highest_stage.height
		
func _process(delta) -> void:
	for stage in get_children():
		if player.position.y < stage.position.y and player.position.distance_to(stage.position) > stage_forgetting_distance:
			stage.call_deferred("free")
	
	if player.position.distance_to(highest_stage.position) < stage_spawn_distance:
		var new_stage = generate_level_stage(highest_stage.position - Vector2(0, highest_stage.height))
		highest_stage = new_stage

func generate_level_stage(position: Vector2) -> Node:
	var template = get_level_template_scene()
	var stage = template.instance()
	add_child(stage)
	stage.position = position
	return stage
	
func get_level_template_scene() -> Resource:
	rng.randomize()
	var random_number = rng.randi_range(1, templates_count)
	var level_path = "res://src/Levels/LevelTemplate%s.tscn"
	level_path = level_path % random_number
	var level_stage: Resource = load(level_path)
	return level_stage
