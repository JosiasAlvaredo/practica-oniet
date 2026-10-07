extends State

var dir_x
var aux_velocity=Vector2.ZERO

func start():
	controle_node.animated_sprite_2d.play("default")
	   
func on_process(delta: float) -> void:
	dir_x = controle_node.direction.x
	
	controle_node.velocity -= aux_velocity
	
	aux_velocity = Vector2(
		move_toward(
			controle_node.velocity.x,
			controle_node.speed * dir_x,
			controle_node.acceleration
		),
		0
	)
	
	aux_velocity = aux_velocity.rotated(controle_node.rotation)
	controle_node.velocity += aux_velocity
	
	if controle_node.is_on_floor():
		state_machine.change_to("Idle")
		

	
		
