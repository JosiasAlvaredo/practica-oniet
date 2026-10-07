extends State

var aux_velocity := Vector2.ZERO
var dir_x

func start():
	controle_node.animated_sprite_2d.play("Move")

func on_process(delta: float) -> void:
	dir_x = controle_node.direction.x
	
	controle_node.velocity -= aux_velocity
	
	aux_velocity = Vector2(
		move_toward(
			controle_node.velocity.x,
			controle_node.speed * -dir_x,
			controle_node.acceleration
		),
		0
	)
	
	aux_velocity = aux_velocity.rotated(controle_node.rotation)
	controle_node.velocity += aux_velocity
	print(controle_node.velocity)
	if dir_x == 0:
		state_machine.change_to("Idle")
	
	if controle_node.velocity.y != 0:
		state_machine.change_to("Fall")

func on_input(event: InputEvent) -> void:
	if Input.is_action_pressed("Jump"):
		state_machine.change_to("Jump")
