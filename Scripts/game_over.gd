extends Panel

@onready var label_tesxt : Label = $Label

func set_label_text(text : String):
	label_tesxt.text = text


func _on_button_pressed() -> void:
	#Recarga la escena con el botón existente
	get_tree().change_scene_to_file("res://Scenes/start.tscn")
