extends State

var mouse_position=Vector2.ZERO
var thread

var waiting=false

func start() -> void:
	waiting=false
	thread=controle_node.left_thread
	mouse_position=controle_node.get_global_mouse_position()

func on_process(delta: float) -> void:

	if not waiting and abs(thread.get_point_position(1))<abs(controle_node.to_local(mouse_position)):
		thread.set_point_position(1,thread.get_point_position(1)+controle_node.to_local(mouse_position)*delta*6)
	else:
		waiting=true

		await get_tree().create_timer(0.2).timeout
		state_machine.change_to("Back")
	if controle_node.left_area.has_overlapping_bodies():
		state_machine.change_to("Hook")
func on_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Left_click"):
		state_machine.change_to("Keep")
