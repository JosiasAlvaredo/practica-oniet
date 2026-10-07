extends State


var thread

func start() -> void:
	thread=controle_node.right_thread
	thread.set_point_position(1,controle_node.right_thread.get_point_position(0))
	

func on_process(delta: float) -> void:
	pass

func on_input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("Right_click"):
		state_machine.change_to("Shoot")
