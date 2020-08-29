extends Area2D

onready var anim_player: AnimationPlayer = get_node("AnimationPlayer")

func _on_body_entered(body: KinematicBody2D) -> void:
	print('body entered')
	anim_player.play("fade_out")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	call_deferred("free")
