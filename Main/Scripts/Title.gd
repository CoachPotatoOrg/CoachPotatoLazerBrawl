extends ColorRect

export(PackedScene) var scene

func _on_Button_button_up():
	get_tree().change_scene_to(scene)

