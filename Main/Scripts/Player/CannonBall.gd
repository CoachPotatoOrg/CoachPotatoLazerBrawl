extends KinematicBody2D

export var damage = 10

var bounces = 0
export var bounce_limit = 2
var ricochet = false

var motion = Vector2()

var collision_info
var collider
var collision_point

export (PackedScene) var hit_explosion


func launch(launch_X,launch_Y):
	motion.x = launch_X
	motion.y = launch_Y


func check_bounces():
	if ricochet:
		if bounces >= bounce_limit:
			queue_free()
	else:
		queue_free()


func _physics_process(delta):
	collision_info = move_and_collide(motion * delta)
	if collision_info:
		ricochet = false
		randomize()
		var dice_roll = randi() % 8
		if dice_roll >= 7:
			motion = motion.bounce(collision_info.normal)
			look_at(motion)
			bounces += 1
			add_to_group("enemy")
			ricochet = true
		collider = collision_info.collider
		collision_point = collision_info.normal
		create_explosion(collision_point)
		if collider != null:
			if collider.is_in_group("enemy"):
				print("boom")
				collider.take_damage(damage)
				print (collider.health)


func create_explosion(collision_point):
	var hit_explosion_instance = hit_explosion.instance()
	
	hit_explosion_instance.rotation_degrees = rad2deg(atan2(collision_point.y, collision_point.x))# * 360/2/PI #THE ROTATION Calculation BASED UPON THE COLLISIONPOINT NORMAL
	hit_explosion_instance.global_position = global_position
	
	Global.Level_Node.add_child(hit_explosion_instance)
	hit_explosion_instance.check_impact_type(collider)
	check_bounces()