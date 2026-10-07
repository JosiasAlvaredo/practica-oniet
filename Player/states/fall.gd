extends State

var dir_x


func start():
	controle_node.animated_sprite_2d.play("default")
	   
func on_process(delta: float) -> void:
	dir_x=controle_node.direction.x
	controle_node.normal_velocity.x=move_toward(controle_node.normal_velocity.x,controle_node.speed*dir_x,controle_node.acceleration)
		
	if controle_node.is_on_floor():
		state_machine.change_to("Idle")
		

	
		
