extends StaticBody

signal remove

var toughness = 30

func _ready():
	pass # Replace with function body.

func remove():
	emit_signal("remove")



