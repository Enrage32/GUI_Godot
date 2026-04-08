extends Node2D


func pause():
	visible = true
	get_tree().paused = true

func resume():
	visible = false
	get_tree().paused = false


func _on_continue_button_down() -> void:
	resume()


func _on_reload_button_down() -> void:
	resume()
	get_tree().reload_current_scene()


func _on_main_menu_button_down() -> void:
	resume()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()
	elif Input.is_action_just_pressed("pause") and not get_tree().paused:
		pause()
