extends State

var start_position=Vector2.ZERO
var thread

var waiting=false

var distance

func start() -> void:
	thread=controle_node.right_thread
	start_position=thread.get_point_position(1)

func on_process(delta: float) -> void:

	if abs(thread.get_point_position(1).length())>10:
		thread.set_point_position(1,thread.get_point_position(1)-thread.get_point_position(1)*delta*6)
	elif not waiting:
		state_machine.change_to("Keep")
		
