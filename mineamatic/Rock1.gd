extends StaticBody

signal remove

var toughness = 50

func _ready():
	pass # Replace with function body.


func remove():
	emit_signal("remove")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
