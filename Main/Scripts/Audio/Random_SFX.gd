extends AudioStreamPlayer2D

export (AudioStream) var sfx_1
export (AudioStream) var sfx_2
export (AudioStream) var sfx_3
export (AudioStream) var sfx_4
export (AudioStream) var sfx_5
export (AudioStream) var sfx_6
export (AudioStream) var sfx_7
export (AudioStream) var sfx_8

export var random_sfx_to_play = 3

func _play_random_sfx():
	var random_sfx = randi() % random_sfx_to_play + 1
	
	match random_sfx:
		1: stream = sfx_1
		2: stream = sfx_2
		3: stream = sfx_3
		4: stream = sfx_4
		5: stream = sfx_5
		6: stream = sfx_6
		7: stream = sfx_7
		8: stream = sfx_8
	
	play()