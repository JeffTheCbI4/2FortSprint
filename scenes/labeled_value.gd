extends Control

@export var _label_text: String
@export var _value: String

# Called when the node enters the scene tree for the first time.
func _ready():
	set_label(_label_text)
	set_value(_value)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_label(label_text):
	_label_text = label_text
	get_node("Label").text = _label_text
	
func set_value(value):
	_value = value
	get_node("Value").text = _value
	
func get_label():
	return _label_text
	
func get_value():
	return _value
