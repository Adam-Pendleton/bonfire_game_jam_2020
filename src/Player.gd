extends KinematicBody2D
export var gravity: int = 30
export var max_fall_speed: int = 1000
export var accel: int = 100
export var max_max_speed: int = 200
export var friction: float = 0.7
export var jump_strength: int = 500

var velocity: Vector2
var facing_left: bool = true
var dead: bool = false

func _ready() -> void:
	pass # Replace with function body.
	
func update_sprite():
	if velocity.x < 0:
		facing_left = true
	elif velocity.x > 0:
		facing_left = false
	if facing_left:
		$Sprite.flip_h = true
	else: 
		$Sprite.flip_h = false
	
func _physics_process(delta: float) -> void:
	if dead:
		return
	var new_velocity = get_new_velocity()
	velocity = move_and_slide(new_velocity, Vector2.UP)
	check_if_dead()
	update_sprite()
	
func check_if_dead() -> void:
	for i in get_slide_count():
		if get_slide_collision(i).collider.name == "Bank":
			dead = true
			set_process(false)

func get_new_velocity() -> Vector2:
	var new_velocity: Vector2 = velocity
	new_velocity = add_gravity(new_velocity)
	new_velocity = add_player_input(new_velocity)
	new_velocity = add_friction(new_velocity)
	return new_velocity

func add_player_input(given_velocity: Vector2) -> Vector2:
	if Input.get_action_strength("right") > 0:
		given_velocity.x += accel
	elif Input.get_action_strength("left") > 0:
		given_velocity.x -= accel
	if Input.get_action_strength("up") > 0 and is_on_floor():
		given_velocity.y = -jump_strength
	
	return given_velocity
	
func add_gravity(given_velocity: Vector2) -> Vector2:
	if given_velocity.y > max_fall_speed:
		given_velocity.y = max_fall_speed
	else:
		given_velocity.y += gravity
	return given_velocity
	
func add_friction(given_velocity: Vector2) -> Vector2:
	given_velocity.x = given_velocity.x * friction
	return given_velocity
