extends State

var dir_x

func start():
	controle_node.animated_sprite_2d.play("Jump")
	controle_node.velocity.y=move_toward(controle_node.velocity.y,-controle_node.jump_force,controle_node.jump_acelerate)
		

func on_process(delta: float) -> void:
	dir_x=controle_node.direction.x
	controle_node.velocity.x=move_toward(controle_node.velocity.x,controle_node.speed*dir_x,-controle_node.acceleration)
		
	if controle_node.velocity.y<0:
		state_machine.change_to("Fall")
		
func on_input(event: InputEvent) -> void:
	if Input.is_action_pressed("Jump"):
		controle_node.velocity.y=-100
	
		
