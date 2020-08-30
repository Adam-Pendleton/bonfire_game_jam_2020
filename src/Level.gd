extends Node2D

onready var rng := RandomNumberGenerator.new()
onready var player := get_node("/root/Game/Player")
export var stage_forgetting_distance = 900
export var stage_spawn_distance = 600

var highest_stage = null
var templates_count = 8
var testing_levels = [2, 1]

func create_initial_level() -> void:	
	var spawn_position: Vector2 = player.position + Vector2(0, 40)
	
	if testing_levels and len(testing_levels) > 0:
		for level in testing_levels:
			highest_stage = place_stage(level, spawn_position)
			spawn_position.y -= highest_stage.height
	else:
		highest_stage = place_stage(0, spawn_position)
		spawn_position.y -= highest_stage.height
		while player.position.distance_to(highest_stage.position) < stage_spawn_distance:
			highest_stage = place_random_stage(spawn_position)
			spawn_position.y -= highest_stage.height
	

func place_random_stage(position: Vector2) -> Node:
	rng.randomize()
	var random_stage_number = rng.randi_range(1, templates_count)
	return place_stage(random_stage_number, position)
		
func place_stage(stage_number: int, position: Vector2) -> Node:
	var level_path = "res://src/Levels/LevelTemplate%s.tscn" % stage_number
	var stage_scene = load(level_path)
	var stage = stage_scene.instance()
	add_child(stage)
	stage.position = position
	return stage
		
func _process(delta) -> void:
	if not get_node("/root/Game").game_started:
		return
		
	for stage in get_children():
		if player.position.y < stage.position.y and player.position.distance_to(stage.position) > stage_forgetting_distance + stage.height:
			stage.call_deferred("free")
	
	if player.position.distance_to(highest_stage.position) < stage_spawn_distance:
		var new_stage = place_random_stage(highest_stage.position - Vector2(0, highest_stage.height))
		highest_stage = new_stage
	
	update()

func clear_stages() -> void:
	for stage in get_children():
		stage.call_deferred("free")

