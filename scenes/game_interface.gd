extends Control
class_name GameInterface

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_value(parameter_name:String, value:String):
	get_node(parameter_name).set_value(str(value)) 

func get_value(parameter_name:String):
	return get_node(parameter_name).get_value() 
