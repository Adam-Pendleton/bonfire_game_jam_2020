extends Node

var game_over: bool = false
var player_start_position := Vector2(300, 100)

func _ready() -> void:
	initialize_level()
	
func _process(delta: float) -> void:
	if game_over and Input.is_action_just_pressed("up") and $ShowScreenTimer.get_time_left() == 0:
		game_over = false
		restart_level()
		
	if $Player.dead and not game_over:
		game_over = true
		show_game_over_screen()

func complete_level() -> void:
	game_over = true
	show_complete_screen()
		
func show_complete_screen() -> void:
	var complete_screen = preload("res://src/Screens/CompleteScreen.tscn").instance()
	add_child(complete_screen)
	$ShowScreenTimer.start(2)
	
func show_game_over_screen() -> void:
	var game_over_screen = preload("res://src/Screens/GameOverScreen.tscn").instance()
	add_child(game_over_screen)
	$ShowScreenTimer.start(2)
	
func restart_level() -> void:
	initialize_level()
	$Bank.reset_speed()
	$Player.clear_money_count()
	if get_node("GameOverScreen"):
		$GameOverScreen.call_deferred("free")
	else:
		$CompleteScreen.call_deferred("free")
	
func initialize_level() -> void:
	$Player.dead = false
	$Player.position = player_start_position
	$Bank.position = $Player.position + Vector2(0, 600)
	$Level.clear_stages()
	$Level.create_initial_level()
