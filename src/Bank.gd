extends KinematicBody2D

export var starting_speed = 1.0
export var acceleration_factor = .001
var speed

func _ready() -> void:
	reset_speed()
	
func _physics_process(delta: float) -> void:
	if get_node("/root/Game").game_over:
		return
	position.y -= speed
	speed += speed * acceleration_factor
	sync_background(position, speed)

func reset_speed() -> void:
	speed = starting_speed
	
func sync_background(position: Vector2, speed: float) -> void:
	var background = get_node("/root/Game/BankBackground")
	background.position = position
