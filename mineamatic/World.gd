extends Spatial

export (int) var num_of_rocks
export (int) var num_of_trees
export (int) var num_of_berries
export (PackedScene) var rock1 = preload("res://Rock1.tscn")
export (PackedScene) var tree1 = preload("res://Tree.tscn")
export (PackedScene) var berry1 = preload("res://Berry.tscn")

func _ready():

	for i in range(num_of_rocks):
		var r = rock1.instance()
		add_child(r)
		r.add_to_group("Rock")
		r.add_to_group("Resource")
		randomize()
		r.global_transform.origin = Vector3( rand_range(-90,90), 0, rand_range(-90,90))
		
	for i in range(num_of_trees):
		var t = tree1.instance()
		add_child(t)
		t.add_to_group("Tree")
		t.add_to_group("Resource")
		randomize()
		t.rotate_y(rand_range(-100,100))
		t.global_transform.origin = Vector3( rand_range(-90,90), 0, rand_range(-90,90))

	for i in range(num_of_berries):
		var b = berry1.instance()
		add_child(b)
		b.add_to_group("Berry")
		b.add_to_group("Resource")
		randomize()
		b.rotate_y(rand_range(-100,100))
		b.global_transform.origin = Vector3( rand_range(-90,90), 0, rand_range(-90,90))
		
func _process(delta):
	$CameraRig.rotate_y(.1 * delta)
