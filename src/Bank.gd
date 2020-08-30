extends KinematicBody2D

export var starting_speed = 1.0
export var acceleration_factor = .001
var speed

func _ready() -> void:
	reset_speed()
	
func _physics_process(delta: float) -> void:
	var game_node = get_node("/root/Game")
	if game_node.game_over or not game_node.game_started:
		return
	position.y -= speed
	speed += speed * acceleration_factor
	sync_background(position, speed)

func reset_speed() -> void:
	speed = starting_speed
	
func sync_background(position: Vector2, speed: float) -> void:
	var background = get_node("/root/Game/BankBackground")
	background.position.x = position.x
	background.position.y = position.y - 15
