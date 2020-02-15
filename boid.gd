extends Node2D

var max_vel = 50

# motion
var rot = 0
var pos = Vector2()
var vel = Vector2()

var target = Vector2()
# debug
var rel_pos = Vector2()
var steer = Vector2(0,0)
var desired = Vector2(0,0)

var wander_angle = 2

# AI
# atan2(0,-1) returns 180 degrees in 3.0, we want 0
# this counts in radians
func fix_atan(x,y):
	var ret = 0
	var at = atan2(x,y)

	if at > 0:
		ret = at - PI
	else:
		ret= at + PI
	
	return ret



	
# AI - steering behaviors
# seek
func get_steering_seek(target, cap=(200/4)):
	var steering = Vector2(0,0)
	desired = target - get_global_position()
	
	desired = desired.normalized() * max_vel
	steering = (desired - vel).clamped(cap)
	return steering
	
	
# arrive
func get_steering_arrive(target):
	var steering = Vector2(0,0)
	desired = target - get_global_position()
	
	var dist = desired.length()
	desired = desired.normalized()
	if dist < 100:
		var m = range_lerp(dist, 0, 100, 0, max_vel) # 100 is our max speed?
		desired = desired * m
	else:
		desired = desired * max_vel
		
	steering = (desired - vel).clamped(max_vel/4) # I don't remember why the /4, sorry...
	return steering

# the bigger the radius/circle dist, the bigger the force	
func get_steering_wander(radius, circle_dist):
	# null the desired vector because we're not using it, it'll only confuse the viewer
	desired = Vector2(0,0)
	
	
	var steering = Vector2(0,0)
	
	var circle_center = vel
	circle_center = circle_center.normalized() * circle_dist
	
	
	# displacement force
	var displacement = Vector2(0,-1)
	displacement = displacement * radius
	
	#var wander_angle = deg2rad(15)
	var angle_change = deg2rad(30)
	
#	if randf() > 0.5:
#		wander_angle += randf() * angle_change - angle_change * .5
#	else:
#		wander_angle -= randf() * angle_change - angle_change * .5
	
	wander_angle += randf() * angle_change - angle_change * .5
	
	#print("Wander angle: " + str(wander_angle))
	
	
	displacement = displacement.rotated(wander_angle)
	
	var wander_force = circle_center + displacement
	
	wander_force.clamped(max_vel/4)
	
	return(wander_force)
	

# don't wander out of sandbox
func wander_in_field():
	var center = Vector2(600, 350)
	
	if get_position().distance_to(center) > 200:
		steer = get_steering_seek(center)
	else:
		steer = get_steering_wander(2, 5)
		
	return steer
