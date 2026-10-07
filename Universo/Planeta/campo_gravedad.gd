extends Area2D

@export var fuerza := 300.0
@onready var antigravity: Area2D = $Antigravity

var objetos = []

func _physics_process(delta):
	for objeto in objetos:
		if not is_instance_valid(objeto):
			continue

		var direccion = global_position - objeto.global_position
		var distancia = direccion.length()

		if distancia <= 1:
			continue
		
		var gravedad = direccion.normalized() * fuerza
		
		if objeto.name == "Player":
			objeto.last_rotation=objeto.rotation
			objeto.rotation = move_toward(objeto.rotation,objeto.global_position.angle_to_point(global_position)-PI/2,10000)
			objeto.gravity=fuerza

		else:
			objeto.velocity.y += gravedad * delta

func _on_body_entered(body):
	if body not in objetos:
		objetos.append(body)

func _on_body_exited(body):
	objetos.erase(body)
