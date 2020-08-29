extends KinematicBody2D

export var speed = 1

func _ready() -> void:
	pass 

func _physics_process(delta: float) -> void:
	if get_node("/root/Game/Player").dead:
		return
	position.y -= speed
