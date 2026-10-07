extends Node
class_name State

var controle_node
var state_machine
func _ready() -> void:
	state_machine=get_parent()

func start() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_process(delta: float) -> void:
	pass

func on_input(event: InputEvent) -> void:
	pass
