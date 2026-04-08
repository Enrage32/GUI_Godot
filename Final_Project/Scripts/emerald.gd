extends Area2D


func _on_body_entered(body: Node2D) -> void:
	body.pick_emerald()
	queue_free()
