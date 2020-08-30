extends Area2D

signal coal_collected

var collected = false

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")


func _on_body_entered(body: KinematicBody2D) -> void:
	if(body && !collected):
		collected = true
		emit_signal("coal_collected")
		call_deferred("free")
	else:
		queue_free()
