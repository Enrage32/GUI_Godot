extends Node2D



func _on_quit_button_down() -> void:
	get_tree().quit()


func _on_start_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
