extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body == Global.player:
		body.health -= 99999
	else:
		body.queue_free()
