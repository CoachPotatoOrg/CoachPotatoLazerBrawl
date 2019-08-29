extends Node2D

func _init():
	Global.Level_Node = self


func _on_Player1Ship_death():
	Global.HUD.win(true)


func _on_Player2Ship_death():
	Global.HUD.win(false)


func _restart_level():
	get_tree().reload_current_scene()
