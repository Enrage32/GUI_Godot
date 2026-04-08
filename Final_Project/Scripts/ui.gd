extends CanvasLayer

@onready var health_label: Label = $Health
@onready var emeralds_label: Label = $Emeralds



func _on_player_collect_emerald(emeralds: Variant) -> void:
	emeralds_label.text = "Emeralds: " + str(emeralds)


func _on_player_health_down(health: Variant) -> void:
	health_label.text = "Lives: " + str(health)
