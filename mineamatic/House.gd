extends Spatial

var _owner = null
var inventory = {}

signal in_house

func _ready():
	inventory["rocks"] = 0
	inventory["wood"] = 0
	inventory["berries"] = 0
	


func _on_HomeArea_body_entered(body):
	if body == _owner:
		emit_signal("in_house")
