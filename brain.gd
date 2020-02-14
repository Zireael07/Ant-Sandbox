extends "boid.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# using this because we don't need physics
func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	
	#target 
	target = get_tree().get_nodes_in_group("leaf")[0].get_global_position()
	

	rel_pos = get_global_transform().xform_inv(target)
	#print("Rel pos: " + str(rel_pos) + " abs y: " + str(abs(rel_pos.y)))
	
	# steering behavior
	var steer = get_steering_arrive(target)
	# normal case
	vel += steer
	
	
	var a = fix_atan(vel.x,vel.y)
	
	
	# movement happens!
	pos += vel * delta
	set_position(pos)
	
	# rotation
	# so that we "face where we're going" in simplest terms
	set_rotation(-a)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
