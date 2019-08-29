extends CanvasLayer

func _init():
	Global.HUD = self


func _ready():
	$PlayAgain.connect("button_up",get_parent(),"_restart_level")


func update_hud():
	$Control/P1Health.value = Global.player_1.health
	$Control/P2Health.value = Global.player_2.health


func win(player_1_win):
	if player_1_win:
		$P1Win.show()
	else:
		$P2Win.show()
	$PlayAgain.show()