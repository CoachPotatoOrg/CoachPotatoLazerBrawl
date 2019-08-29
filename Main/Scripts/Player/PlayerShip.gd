extends KinematicBody2D

export var player_id = 1

export var ship_health = 100

export (int) var speed = 200
export (float) var acceleration = 0.5
export (float) var rotation_speed = 1.5

export (PackedScene) var standard_cannon_laser

var velocity = Vector2()
var rotation_dir = 0

var friction = 0.2

onready var broadside_left = $FireBroadsideLeft
onready var broadside_right = $FireBroadsideRight

var can_fire = true

func get_input():
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
    get_input()
    rotation += rotation_dir * rotation_speed * delta
    velocity = move_and_slide(velocity)


func fire_cannon_left_side():
	pass