extends KinematicBody2D
export var gravity: int = 35
export var max_fall_speed: int = 1000
export var accel: int = 100
export var max_speed: int = 200
export var friction: float = 0.3
export var air_resistance: float = 0.2
export var air_accel: float = 70
export var jump_strength: int = 660

var jump_count = 0
var velocity: Vector2
var facing_left: bool = true
var dead: bool = false

var coal_count = 0
var money_count = 0
var money_bag_value = 3

signal coal_count_changed
signal money_count_changed

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")

func update_sprite():
	if velocity.y < 0:
		anim_player.play("jump")
	elif velocity.y > 0:
		anim_player.play("fall")
	elif velocity.abs().x <= 20:
		anim_player.play("idle")
	else:
		anim_player.play("run")
	
	if velocity.x < 0:
		facing_left = true
	elif velocity.x > 0:
		facing_left = false
		
	var sprite = get_node("player_sprite")
	if facing_left:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
func _physics_process(delta: float) -> void:
	if dead:
		return
	if Input.is_action_just_pressed("drop_money"):
		drop_money()
	
	var new_velocity = get_new_velocity()
	if is_on_floor():
		jump_count = 0
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
	new_velocity = add_player_input(new_velocity)
	new_velocity = add_gravity(new_velocity)
	if is_on_floor():
		new_velocity = add_friction(new_velocity)
	else:
		new_velocity = add_air_resistance(new_velocity)
		
	return new_velocity

func add_player_input(given_velocity: Vector2) -> Vector2:
	if Input.get_action_strength("right") > 0:
		if is_on_floor():
			given_velocity.x += accel
		else:
			given_velocity.x += air_accel
	elif Input.get_action_strength("left") > 0:
		if is_on_floor():
			given_velocity.x -= accel
		else:
			given_velocity.x -= air_accel
	
	if Input.is_action_just_pressed("up") and jump_count < 1:
		given_velocity.y = -jump_strength
		jump_count += 1
		
	if Input.is_action_just_released("up") and given_velocity.y < -jump_strength / 2:
		given_velocity.y = -jump_strength / 2
	
	return given_velocity
	
func add_gravity(given_velocity: Vector2) -> Vector2:
	if given_velocity.y > max_fall_speed:
		given_velocity.y = max_fall_speed
	else:
		given_velocity.y += gravity
	return given_velocity
	
func add_friction(given_velocity: Vector2) -> Vector2:
	given_velocity.x = lerp(given_velocity.x, 0, friction)
	return given_velocity

func add_air_resistance(given_velocity: Vector2) -> Vector2:
	given_velocity.x = lerp(given_velocity.x, 0, air_resistance)
	return given_velocity
	
func on_coal_collected() -> void:
	coal_count = (coal_count + 1) % money_bag_value
	if coal_count == 0:
		money_count += 1
		emit_signal("money_count_changed", money_count)
	emit_signal("coal_count_changed", coal_count)
		
func can_shoot_money() -> bool:

	return money_count > 0
	
func decrease_money_count() -> void:
	money_count -= 1
	emit_signal("money_count_changed", money_count)

func clear_money_count() -> void:
	money_count = 0
	coal_count = 0
	emit_signal("money_count_changed", money_count)
	emit_signal("coal_count_changed", coal_count)
	
func indicate_no_money() -> void:
	pass

func drop_money() -> void:
	if can_shoot_money():
		var money_bag_scene = preload("res://src/Objects/MoneyBag.tscn")
		var money_bag = money_bag_scene.instance()
		money_bag.position = position
		get_parent().add_child(money_bag)
		decrease_money_count()
	else:
		#nice to have feature:
		indicate_no_money()
