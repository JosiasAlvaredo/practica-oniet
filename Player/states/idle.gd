extends State

var aux_velocity=Vector2.ZERO
var dir_x

func start():
	controle_node.animated_sprite_2d.play("default")

func on_process(delta: float) -> void:
	dir_x=controle_node.direction.x

	controle_node.velocity =Vector2(0,0)
	if dir_x!=0:
		state_machine.change_to("Move")
		
	if not controle_node.is_on_floor():
		state_machine.change_to("Fall")

func on_input(event: InputEvent) -> void:
	if Input.is_action_pressed("Jump"):
		state_machine.change_to("Jump")
