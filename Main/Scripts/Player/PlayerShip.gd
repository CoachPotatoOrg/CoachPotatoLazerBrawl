extends KinematicBody2D

signal death

export var player_id = 1

export var health = 100

export (int) var speed = 200
export (float) var acceleration = 0.5
export (float) var rotation_speed = 1.5

export (PackedScene) var standard_cannon_laser

export var cannon_ball_launch_speed = 300
export var cannon_ball_spread_min = -300.0
export var cannon_ball_spread_max = 300.0

var motion = Vector2()
var velocity = Vector2()
var rotation_dir = 0

var loose_friction = true

onready var broadside_left = $FireBroadsideLeft
onready var broadside_right = $FireBroadsideRight

var can_fire_left = true
var can_fire_right = true

var has_input = true


func _ready():
	if player_id == 1:
		Global.player_1 = self
	else:
		Global.player_2 = self


func get_movement_input():
    rotation_dir = 0
    motion = Vector2()
    if Input.is_action_pressed("RightP%s" % player_id):
        rotation_dir += 1
    if Input.is_action_pressed("LeftP%s" % player_id):
        rotation_dir -= 1
    if Input.is_action_pressed("downP%s" % player_id):
        motion = Vector2(-speed, 0).rotated(rotation)
    if Input.is_action_pressed("upP%s" % player_id):
        motion = Vector2(speed, 0).rotated(rotation)


func _physics_process(delta):
	if has_input:
			get_movement_input()
			rotation += rotation_dir * rotation_speed * delta
			motion = move_and_slide(motion)
	if loose_friction:
		motion.x = lerp(motion.x, 0, 0.8)


func _input(event):
	if has_input:
		if Input.is_action_just_pressed("fire_leftP%s" % player_id):
			if can_fire_left:
				fire_cannon_left_side()
		if Input.is_action_just_pressed("fire_rightP%s" % player_id):
			if can_fire_right:
				fire_cannon_right_side()


func fire_cannon_left_side():
	$ShipAnims.play("FireLeft")
	can_fire_left = false
	
	var target = $FireBroadsideLeft/FireBroadsideLeftTarget.global_position
	var cannon_ball_instance = standard_cannon_laser.instance()
	cannon_ball_instance.position = $FireBroadsideLeft.global_position
	velocity = (target - broadside_left.global_position).normalized() * cannon_ball_launch_speed
	randomize()
	cannon_ball_instance.launch(velocity.x ,velocity.y)
	cannon_ball_instance.look_at(target)
	Global.Level_Node.add_child(cannon_ball_instance)
	
	$CooldownLeftSide.start()


func fire_cannon_right_side():
	can_fire_right = false
	$ShipAnims.play("FireRight")
	
	var target = $FireBroadsideRight/FireBroadsideRightTarget.global_position
	var cannon_ball_instance = standard_cannon_laser.instance()
	cannon_ball_instance.position = $FireBroadsideRight.global_position
	velocity = (target - broadside_right.global_position).normalized() * cannon_ball_launch_speed
	randomize()
	cannon_ball_instance.launch(velocity.x ,velocity.y)
	cannon_ball_instance.look_at(target)
	Global.Level_Node.add_child(cannon_ball_instance)
	
	$CooldownRightSide.start()


func _on_CooldownLeftSide_timeout():
	can_fire_left = true
	print("canfireleft", can_fire_left)


func _on_CooldownRightSide_timeout():
	can_fire_right = true
	print("canfireleft", can_fire_right)


func take_damage(damage_to_take):
	health -= damage_to_take
	if health <= 0:
		destroy()
		health = 0
	Global.HUD.update_hud()


func destroy():
	emit_signal("death")
	has_input = false
	$ShipAnims.play("death")