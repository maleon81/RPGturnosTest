extends Node2D

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/batle_scene.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
