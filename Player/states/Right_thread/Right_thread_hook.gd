extends State

var save_position=Vector2.ZERO
var thread

var waiting=false

var distance
var vecDistance

func start() -> void:
	thread=controle_node.right_thread
	save_position=thread.to_global(thread.get_point_position(1))
	vecDistance = thread.to_global(save_position) - controle_node.global_position
	distance = vecDistance.length()

	
	

func on_process(delta: float) -> void:

	
	var target = thread.to_global(thread.get_point_position(1))
	
	vecDistance = target - controle_node.global_position
	distance = vecDistance.length()
	print(distance)
	var direction = controle_node.global_position.direction_to(target)
	controle_node.velocity += direction * distance *Vector2(30,5) *delta

	# Mantener el punto en la misma posición global
	thread.set_point_position(
		1,
		thread.to_local(target-(target-save_position))
	)
func on_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Right_click"):
		state_machine.change_to("Back")
