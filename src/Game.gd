extends Node

var game_over: bool = false

func _ready() -> void:
	pass
	
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
	$Player.dead = false
	$Player.position = Vector2(40,40)
	$Bank.position = $Player.position + Vector2(0, 600)
	$Level.clear_stages()
	$Level.create_initial_level()
	$GameOverScreen.call_deferred("free")
