extends Node2D

@onready var imagen: Sprite2D = $Sprite2D
@onready var texto: Label = $Label
@onready var musica: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var text_audio: AudioStreamPlayer2D = $text_audio


func _physics_process(delta: float):
	
	if Input.is_action_just_pressed("Jump"):
		musica.play()
		# VIÑETA 1
		await mostrar_escena(
			preload("res://assets/Animacion/viñetoide1.png"),
			"Un grupo de aventureros se enfrentaba al enemigo más legendario de la mazmorra... Aldrak»"
		)
		await esperar_y_desaparecer()


		# VIÑETA 2
		await mostrar_escena(
			preload("res://assets/Animacion/viñetoide2.png"),
			"El mago creó un golem para ayudar al grupo. Su nombre era Theseus. Y recibió una única orden. «Mata a Aldrak.»"
		)
		await esperar_y_desaparecer()


		# VIÑETA 3
		await muertes("Uno a uno... los héroes cayeron.")
		await viñeta3()


		# VIÑETA 4
		await mostrar_escena(
			preload("res://assets/Animacion/viñetoide4.png"),
			"Solo quedó Theseus. Pero no por mucho tiempo."
		)
		await viñeta4()


		# VIÑETA 5
		await mostrar_escena(
			preload("res://assets/Animacion/viñetoide5.png"),
			"Con cada golpe... su cuerpo se desarmaba."
		)
		await esperar_y_desaparecer()


		# VIÑETA 6
		await mostrar_escena(
			preload("res://assets/Animacion/viñetoide6.png"),
			"Hasta que solo quedó su cabeza."
		)
		await esperar_y_desaparecer()


		# PANTALLA NEGRA
		await pantalla_negra("Pero...")


		# VIÑETA 7
		await mostrar_escena(
			preload("res://assets/Animacion/viñetoide7.png"),
			"...aún estaba vivo."
		)
		await esperar_y_desaparecer()


		# VIÑETA 8
		await mostrar_escena(
		preload("res://assets/Animacion/viñetoide8.5.png"),
		"Y TIENES una misión. Mata a Aldrak."
		)

		# Esperar a que termine la canción
		await esperar_fin_de_musica()

		# Esperar un segundo
		await get_tree().create_timer(1.0).timeout

		# Fadeout final
		await fadeout_final()

		# Cambiar al menú
		get_tree().change_scene_to_file("res://interface/menu/menu.tscn")

func mostrar_escena(nueva_imagen: Texture2D, nuevo_texto: String):
	imagen.visible = true

	imagen.texture = nueva_imagen

	imagen.modulate.a = 0.0
	texto.modulate.a = 0.0
	texto.text = ""

	# Aparece la imagen
	var tween = create_tween()
	tween.tween_property(imagen, "modulate:a", 1.0, 1.0)

	await tween.finished

	# Pequeña pausa
	await get_tree().create_timer(0.5).timeout

	# Aparece el texto
	await escribir_texto(nuevo_texto)


func escribir_texto(nuevo_texto: String):
	
	texto.text = ""
	texto.modulate.a = 1.0

	for caracter in nuevo_texto:
		text_audio.play()
		texto.text += caracter
		await get_tree().create_timer(0.02).timeout


func esperar_y_desaparecer():
	await get_tree().create_timer(3.0).timeout


func viñeta3():
	await get_tree().create_timer(5).timeout


func viñeta4():
	await get_tree().create_timer(2.0).timeout

	# Imagen y texto desaparecen juntos
	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(imagen, "modulate:a", 0.0, 1.0)
	tween.tween_property(texto, "modulate:a", 0.0, 1.0)

	await tween.finished

	texto.text = ""


func muertes(nuevo_texto: String):
	mostrar_escena(
				null,
				"Uno a uno... los héroes cayeron."
			)
	await get_tree().create_timer(4.5).timeout
	imagen.texture = preload("res://assets/Animacion/dead1.png")
	await get_tree().create_timer(2).timeout
	imagen.texture = preload("res://assets/Animacion/dead2.png")
	await get_tree().create_timer(2.5).timeout
	imagen.texture = preload("res://assets/Animacion/dead3.png")
	await get_tree().create_timer(3.5).timeout
	imagen.texture = preload("res://assets/Animacion/viñetoide3.png")

	
	
func pantalla_negra(nuevo_texto: String):
	# Ocultar imagen
	imagen.visible = false

	# Limpiar texto
	texto.text = ""
	texto.modulate.a = 0.0

	# Texto aparece
	var tween = create_tween()
	tween.tween_property(texto, "modulate:a", 1.0, 0.5)

	await tween.finished

	await escribir_texto(nuevo_texto)

	# Mantener "Pero..." un momento
	await get_tree().create_timer(1.5).timeout

	# Desaparecer texto
	var tween2 = create_tween()
	tween2.tween_property(texto, "modulate:a", 0.0, 1.0)

	await tween2.finished


func esperar_fin_de_musica():
	# Si la música ya terminó, no esperamos
	if not musica.playing:
		return

	# Esperamos mientras siga reproduciéndose
	while musica.playing:
		await get_tree().process_frame

func fadeout_final():
	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(imagen, "modulate:a", 0.0, 1.0)
	tween.tween_property(texto, "modulate:a", 0.0, 1.0)

	await tween.finished
