extends KinematicBody2D

export var damage = 10
export var launch_speed = 300

export(float) var _speed

var bounces = 0
export var bounce_limit = 2

var motion = Vector2()

var collision_info
var collider
var collision_point

export (PackedScene) var hit_explosion


func launch(launch_X,launch_Y):
	motion.x = launch_X
	motion.y = launch_Y


func _physics_process(delta):
	collision_info = move_and_collide(motion * delta)
	if collision_info:
#		ricochet = false
#		randomize()
#		var dice_roll = randi() % 8
#		if dice_roll >= 7:
#			motion = motion.bounce(collision_info.normal)
#			look_at(motion)
#			bounces += 1
#			add_to_group("enemy")
#			ricochet = true
		
		collider = collision_info.collider
		collision_point = collision_info.normal
		if collider != null:
			if collider.is_in_group("bounceblock"):
				motion = motion.bounce(collision_info.normal)
				look_at(motion)
				bounces += 1
				print("bounce")
			else:
				bounces = bounce_limit
			if collider.has_method("take_damage"):
				print("boom")
				collider.take_damage(damage)
				print (collider.health)
#				add_to_group("enemy")
		create_explosion(collision_point)


func create_explosion(collision_point):
	var hit_explosion_instance = hit_explosion.instance()
	
	hit_explosion_instance.rotation_degrees = rad2deg(atan2(collision_point.y, collision_point.x))# * 360/2/PI #THE ROTATION Calculation BASED UPON THE COLLISIONPOINT NORMAL
	hit_explosion_instance.global_position = global_position
	
	Global.Level_Node.add_child(hit_explosion_instance)
	check_bounces()


func check_bounces():
	if bounces >= bounce_limit:
		queue_free()