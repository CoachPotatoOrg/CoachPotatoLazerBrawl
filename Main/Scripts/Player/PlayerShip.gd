extends KinematicBody2D

export var player_id = 1

export var ship_health = 100

export (int) var speed = 200
export (float) var acceleration = 0.5
export (float) var rotation_speed = 1.5

export (PackedScene) var standard_cannon_laser

export var cannon_ball_launch_speed = 1800
export var cannon_ball_spread_min = -300.0
export var cannon_ball_spread_max = 300.0

var velocity = Vector2()
var rotation_dir = 0

var friction = 0.2

onready var broadside_left = $FireBroadsideLeft
onready var broadside_right = $FireBroadsideRight

var can_fire_left = true
var can_fire_right = true

func get_movement_input():
    rotation_dir = 0
    velocity = Vector2()
    if Input.is_action_pressed("RightP%s" % player_id):
        rotation_dir += 1
    if Input.is_action_pressed("LeftP%s" % player_id):
        rotation_dir -= 1
    if Input.is_action_pressed("downP%s" % player_id):
        velocity = Vector2(-speed, 0).rotated(rotation)
    if Input.is_action_pressed("upP%s" % player_id):
        velocity = Vector2(speed, 0).rotated(rotation)


func _physics_process(delta):
    get_movement_input()
    rotation += rotation_dir * rotation_speed * delta
    velocity = move_and_slide(velocity)


func _input(event):
	if Input.is_action_just_pressed("fire_leftP%s" % player_id):
		if can_fire_left:
			fire_cannon_left_side()
	if Input.is_action_just_pressed("fire_rightP%s" % player_id):
		if can_fire_right:
			fire_cannon_right_side()


func fire_cannon_left_side():
	$AnimationPlayer.play("FireLeft")
	can_fire_left = false
	
	var target = $FireBroadsideLeft/FireBroadsideLeftTarget.global_position
	var cannon_ball_instance = standard_cannon_laser.instance()
	cannon_ball_instance.position = $FireBroadsideLeft.global_position
	randomize()
	cannon_ball_instance.launch(velocity.x + int(rand_range (cannon_ball_spread_min,cannon_ball_spread_max)),velocity.y)
	cannon_ball_instance.look_at(target)
	Global.Level_Node.add_child(cannon_ball_instance)
	
	$CooldownLeftSide.start()


func fire_cannon_right_side():
	can_fire_right = false
	$AnimationPlayer.play("FireRight")
	
	var target = $FireBroadsideRight/FireBroadsideRightTarget.global_position
	var cannon_ball_instance = standard_cannon_laser.instance()
	cannon_ball_instance.position = $FireBroadsideRight.global_position
	randomize()
	cannon_ball_instance.launch(velocity.x + int(rand_range (cannon_ball_spread_min,cannon_ball_spread_max)),velocity.y)
	cannon_ball_instance.look_at(target)
	Global.Level_Node.add_child(cannon_ball_instance)
	
	$CooldownLeftSide.start()


func _on_CooldownLeftSide_timeout():
	can_fire_left = true
	print("canfireleft", can_fire_left)


func _on_CooldownRightSide_timeout():
	can_fire_right = true
	print("canfireleft", can_fire_right)


func _on_ShotsFired_animation_finished():
	pass # Replace with function body.
