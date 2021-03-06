extends Area2D

export var speed = 10
var already_hit = false

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	position.y += speed
	
func _on_MoneyBag_body_entered(body: Node) -> void:
	var bank = body
	if not already_hit:
		bank.deposit_money()
	already_hit = true
	call_deferred("free")
