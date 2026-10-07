extends Node
class_name State_machine

@export var initState:State 
var current_state:State 

var controle_node

func _ready() -> void:
	controle_node=get_parent()
	current_state=initState
	current_state.controle_node=controle_node

func start(new_state) -> void:
	current_state=new_state
	current_state.controle_node=controle_node
	current_state.start()
	
	
func _process(delta: float) -> void:
	current_state.on_process(delta)
	
func _input(event: InputEvent) -> void:
	current_state.on_input(event)
	
func change_to(state_name):
	var new_state=get_node_or_null(state_name)
	
	if new_state != null:
		start(new_state)
	else:
		return
