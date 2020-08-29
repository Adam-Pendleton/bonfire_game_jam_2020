extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var game_over: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
