extends Node

var game_over: bool = false
var player_start_position := Vector2(300, 100)

func _ready() -> void:
	initialize_level()
	
func _process(delta: float) -> void:
	if game_over and Input.get_action_strength("up") > 0:
		game_over = false
		restart_level()
		
	if $Player.dead and not game_over:
		game_over = true
		show_game_over_screen()
		
func show_game_over_screen() -> void:
	var game_over_screen = preload("res://src/Screens/GameOverScreen.tscn").instance()
	var texture = game_over_screen.get_node("TextureRect")
	texture.rect_size = get_viewport().size
	add_child(game_over_screen)

func restart_level() -> void:
	initialize_level()
	$Bank.reset_speed()
	$GameOverScreen.call_deferred("free")
	
func initialize_level() -> void:
	$Player.dead = false
	$Player.position = player_start_position
	$Bank.position = $Player.position + Vector2(0, 600)
	$Level.clear_stages()
	$Level.create_initial_level()
