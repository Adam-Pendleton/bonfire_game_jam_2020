extends Node

var game_over: bool = false
var game_started: bool = false
var intro_slide_number: int = 0
var on_splash_screen: bool = false
var current_screen = null
var show_intro = true
var player_start_position := Vector2(300, 100)
onready var intro_slides: Array = [
	[preload("res://assets/images/screens/Title-Page.png"), "", ""],
	[preload("res://assets/images/screens/master_of_mine_arts.png"), "I just graduated with a Bachelors of Mine Arts!\n\nNow I need to pay back all that debt!", ""],
	[preload("res://assets/images/screens/sweet_axe.png"), "Wow!", ""],
	[preload("res://assets/images/screens/broke.png"), "Where will I get startup cash?", "I CAN HELP YOU WITH THAT..."],
	[preload("res://assets/images/screens/looming_bank.png"), "", "YOU CAN BORROW FROM MEEEEEE!!"]
]

func _ready() -> void:
	if show_intro:
		 show_intro()
	else:
		start_game()
	start_music()

func _process(delta: float) -> void:
	if not game_started and Input.is_action_just_pressed("drop_money"):
		progress_intro()
	
	if not game_started and Input.is_action_just_pressed("skip"):
		start_game()
	
	if game_over and game_started and Input.is_action_just_pressed("drop_money") and $ShowScreenTimer.get_time_left() == 0:
		game_over = false
		restart_level()
			
	if game_started and $Player.dead and not game_over:
		game_over = true
		show_game_over_screen()

func complete_level() -> void:
	game_over = true
	show_complete_screen()

func show_intro() -> void:
	var intro_screen = preload("res://src/Screens/IntroScreen.tscn").instance()
	intro_screen.get_node("TextureRect/Art").modulate = Color(1,1,1,1)
	intro_screen.get_node("TextureRect/Art").texture = intro_slides[1][0]
	current_screen = intro_screen
	add_child(intro_screen)
	
func show_splash_screen() -> void:
	on_splash_screen = true
	current_screen.call_deferred("free")
	var splash_screen = preload("res://src/Screens/SplashScreen.tscn").instance()
	current_screen = splash_screen
	add_child(splash_screen)
	
func start_game() -> void:
	if current_screen:
		current_screen.call_deferred("free")
	game_started = true
	restart_level()	
	
func progress_intro() -> void:
	if $IntroScreen.get_node("Timer").time_left > 0:
		return

	intro_slide_number += 1

	if intro_slide_number > len(intro_slides) - 1:
		start_game()
	elif intro_slide_number == 1:
		$IntroScreen.get_node("Timer").start(1.6)
		$IntroScreen.get_node("Fader").play("big_fade_out")
		yield(get_tree().create_timer(.6), "timeout")
		$IntroScreen.get_node("TextureRect/Art").texture = intro_slides[intro_slide_number][0]
		$IntroScreen.get_node("TextureRect/ColeText").text = intro_slides[intro_slide_number][1]
		$IntroScreen.get_node("TextureRect/BankText").text = intro_slides[intro_slide_number][2]
	else:
		$IntroScreen.get_node("Timer").start(1.2)
		$IntroScreen.get_node("Fader").play("fade_out")
		yield(get_tree().create_timer(.6), "timeout")
		$IntroScreen.get_node("TextureRect/Art").texture = intro_slides[intro_slide_number][0]
		$IntroScreen.get_node("Fader").play("fade_in")
		$IntroScreen.get_node("TextureRect/ColeText").text = intro_slides[intro_slide_number][1]
		$IntroScreen.get_node("TextureRect/BankText").text = intro_slides[intro_slide_number][2]
	

func show_complete_screen() -> void:
	var complete_screen = preload("res://src/Screens/CompleteScreen.tscn").instance()
	add_child(complete_screen)
	current_screen = complete_screen
	$ShowScreenTimer.start(1)
	
func show_game_over_screen() -> void:
	var game_over_screen = preload("res://src/Screens/GameOverScreen.tscn").instance()
	add_child(game_over_screen)
	current_screen = game_over_screen
	$ShowScreenTimer.start(.5)
	
func restart_level() -> void:
	initialize_level()
	$Bank.reset_speed()
	$Player.clear_money_count()
	if current_screen:
		current_screen.call_deferred("free")
	
func initialize_level() -> void:
	$Player.dead = false
	$Player.position = player_start_position
	$Bank.position = $Player.position + Vector2(0, 600)
	$Level.clear_stages()
	$Level.create_initial_level()
	
func start_music() -> void:
	$MusicStart.play()
	yield($MusicStart, "finished")
	$MusicBody.play()
