extends StaticBody

signal remove

var toughness = 20

func _ready():
	pass # Replace with function body.
	
func remove():
	emit_signal("remove")

