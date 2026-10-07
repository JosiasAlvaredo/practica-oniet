extends Area2D

@export var fuerza := 500.0

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

		objeto.velocity += gravedad * delta

func _on_body_entered(body):
	if body not in objetos:
		objetos.append(body)

func _on_body_exited(body):
	objetos.erase(body)
