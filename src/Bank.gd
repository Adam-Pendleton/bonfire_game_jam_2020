extends KinematicBody2D

export var starting_speed = 1.0
export var acceleration_factor = .001

var knockback = 15
var speed

func _ready() -> void:
	reset_speed()
	
func deposit_money() -> void:
	$DepositSound.play(0)
	reset_speed()
	position.y += knockback
	$StunTimer.start($StunTimer.time_left + 1.5)
	
func _physics_process(delta: float) -> void:
	var game_node = get_node("/root/Game")
	if game_node.game_over or not game_node.game_started:
		return
	if $StunTimer.time_left == 0:
		position.y -= speed
		speed += speed * acceleration_factor
	else:
		position.y += 0.5
	sync_background(position, speed)

func reset_speed() -> void:
	speed = starting_speed
	
func sync_background(position: Vector2, speed: float) -> void:
	var background = get_node("/root/Game/BankBackground")
	background.position.x = position.x
	background.position.y = position.y - 15
