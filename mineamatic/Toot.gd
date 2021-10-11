extends KinematicBody

export (PackedScene) var house_res = preload("res://House.tscn")

var speed = 30
var can_hit = true
var tick = 0
var velocity = Vector3.ZERO
var gravity = Vector3.DOWN * 40
var target = null
var target_list = []
var target_object = null
var home = null
var num_rocks = 0
var num_trees = 0
var inventory = {}
enum STATE {IDLE, GOING_HOME, SEARCHING, TARGETING, HARVESTING}
enum GOAL {TOOLS, FOOD, SHELTER, GATHER}
var state = STATE.SEARCHING
var goal = GOAL.GATHER

#stats
var stamina = 10
var health = 10
var hunger = 10
var strength = 10
var burden = 0

func _ready():
	inventory["rocks"] = 0
	inventory["wood"] = 0
	inventory["berries"] = 0

func _physics_process(delta):
	
	update_stats()
	
	set_goals()
	
	achieve_goals()
	
	if state == STATE.SEARCHING:
		search_move(delta)
		
	if state == STATE.TARGETING:
		go_to_target(delta)
	
	if state == STATE.GOING_HOME:
		go_to_target(delta)
	
	if state == STATE.HARVESTING:
		if can_hit:
			harvest()	
		
func update_stats():

	for i in inventory:
		burden += inventory[i]
	if tick % 10 == 0:
		hunger -=1
		stamina -=.5
	pass
	
func set_goals():
#do we need shelter?
	if home == null:
		goal = GOAL.SHELTER
#do we need food?
	if hunger < 4:
		goal = GOAL.FOOD
#do we have too much to carry?
	if burden > 10:
		goal = GOAL.SHELTER
#can we make a house?
#	if inventory["rocks"] > 3 and inventory["wood"] > 3 and home == null:
#		var house = house_res.instance()
#		get_parent().add_child(house)
#		home = house
#		house.global_transform = global_transform
#		house.scale = Vector3(3,3,3)
#		home._owner = self
#		home.connect("in_house", self, "is_in_house")
#		dump_inventory_in_house()
#
##should we go to the house?	
#	var burden = 0
#	for i in inventory:
#		burden += inventory[i]
#	if burden >= 10 and home != null:
#		print("going home")
#		print(inventory)
#		target = home
#		state = STATE.GOING_HOME 
#	pass

func achieve_goals():
#are we hungry?
	if goal == GOAL.FOOD:
		if target == null and state != STATE.SEARCHING:
			state = STATE.SEARCHING
			
	if goal == GOAL.SHELTER:
#can we make a house?
		if inventory["rocks"] > 3 and inventory["wood"] > 3 and home == null:
			var house = house_res.instance()
			get_parent().add_child(house)
			home = house
			house.global_transform = global_transform
			house.scale = Vector3(3,3,3)
			home._owner = self
			home.connect("in_house", self, "is_in_house")
			dump_inventory_in_house()
#should we go to the house?	
		var burden = 0
		for i in inventory:
			burden += inventory[i]
		if burden >= 10 and home != null:
			print("going home")
			print(inventory)
			target = home
			state = STATE.GOING_HOME 
	
func search_move(delta):
#move forward according to rotation
	velocity += gravity * delta
	var vy = velocity.y
	velocity = Vector3.FORWARD
	velocity += transform.basis.x * speed
	global_transform = transform
	velocity.y = vy
	move_and_slide(velocity, Vector3.DOWN)
	
func go_to_target(delta):
#rotate to look at target
	var self_origin = self.get_global_transform().origin
	var target_origin = target.get_global_transform().origin
	var move_dir = target_origin - self_origin
	move_dir = move_dir.normalized() * speed
	move_and_slide(move_dir * speed * delta)

func dump_inventory_in_house():
	home.inventory["rocks"] += inventory["rocks"]
	inventory["rocks"] = 0
	home.inventory["wood"] += inventory["wood"]
	inventory["wood"] = 0
	home.inventory["berries"] += inventory["berries"]
	inventory["berries"] = 0
	
	#for i in home.inventory:
	print(home.inventory)
	
	
func _on_target_removed():
	target = null
	target_object = null
	state = STATE.SEARCHING
	
	
func harvest():
	state = STATE.HARVESTING
	target_object.toughness -= strength
	if target_object.toughness <= 0:
		pickup(target_object)
		return
	can_hit = false
	$ActionTime.start(.5)
		
func pickup(body):
	if body.is_in_group("Rock"):# and inventory < 8:
		if inventory["rocks"] >=5:
			print("full of rocks")
#			body.emit_signal("remove")
#			body.call_deferred("free")
			target = null
			state = STATE.SEARCHING
			$ThinkingTime.start(.5)
			
		inventory["rocks"] +=1
		print(self.name + " got rock. #: " + str(inventory["rocks"]))
		body.emit_signal("remove")
		body.call_deferred("free")
		target = null
		state = STATE.SEARCHING
		$ThinkingTime.start(.5)
		
	if body.is_in_group("Tree"):# and inventory < 8:
		#are we full of wood?
		if inventory["wood"] >=5:
			print("full of wood")
#			body.emit_signal("remove")
#			body.call_deferred("free")
			target = null
			state = STATE.SEARCHING
			$ThinkingTime.start(.5)
			
		inventory["wood"] +=1
		print(self.name + " got tree. #: " + str(inventory["wood"]))
		body.emit_signal("remove")
		body.call_deferred("free")
		target = null
		state = STATE.SEARCHING
		$ThinkingTime.start(.5)
		
	if body.is_in_group("Berry"):# and inventory < 8:
		#are we full of berries? 
		if inventory["berries"] >=5:
			print("full of berries")
#			body.emit_signal("remove")
#			body.call_deferred("free")
			target = null
			state = STATE.SEARCHING
			$ThinkingTime.start(.5)
			
		inventory["berries"] +=1
		print(self.name + " got berry. #: " + str(inventory["berries"]))
		body.emit_signal("remove")
		body.call_deferred("free")
		target = null
		state = STATE.SEARCHING
		$ThinkingTime.start(.5)
	
		
func _on_Area_body_entered(body):
	
	if body.is_in_group("Resource"):
		print("recource found")
		target_object = body
		$ActionTime.start(.5)
		state = STATE.HARVESTING
		
#
##can we make a house?
#	if inventory["rocks"] > 3 and inventory["wood"] > 3 and home == null:
#		var house = house_res.instance()
#		get_parent().add_child(house)
#		home = house
#		house.global_transform = global_transform
#		house.scale = Vector3(3,3,3)
#		home._owner = self
#		home.connect("in_house", self, "is_in_house")
#		dump_inventory_in_house()
#
##should we go to the house?	
#	var burden = 0
#	for i in inventory:
#		burden += inventory[i]
#	if burden >= 10 and home != null:
#		print("going home")
#		print(inventory)
#		target = home
#		state = STATE.GOING_HOME 
#

func _on_Sight_body_entered(body):
	if body.is_in_group("Rock"):
		if target == null:
			target = body
			body.connect("remove", self, "_on_target_removed")
			state = STATE.TARGETING
			
	if body.is_in_group("Tree"):
		if target == null:
			target = body
			body.connect("remove", self, "_on_target_removed")
			state = STATE.TARGETING	

	if body.is_in_group("Berry"):
		if target == null:
			target = body
			body.connect("remove", self, "_on_target_removed")
			state = STATE.TARGETING		
		
func _on_ThinkingTime_timeout():
	if state == STATE.SEARCHING:
		rotate_y(rand_range(-2,2))
		tick += 1
		$ThinkingTime.start(.5)

func is_in_house():
	#print("entering house in state: " + str(state))
	if state == STATE.GOING_HOME:
		dump_inventory_in_house()
		target = null
		state = STATE.SEARCHING
		#print("starting search in state: " + str(state))
		$ThinkingTime.start(.5)
		

func _on_ActionTime_timeout():
	can_hit = true
	#$ActionTime.start(.5)
