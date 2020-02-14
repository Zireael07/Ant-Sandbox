extends Node2D

var max_vel = 200

# motion
var rot = 0
var pos = Vector2()
var vel = Vector2()

var target = Vector2()
# debug
var rel_pos = Vector2()
var steer = Vector2(0,0)
var desired = Vector2(0,0)

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
		
	steering = (desired - vel).clamped(max_vel/4)
	return steering