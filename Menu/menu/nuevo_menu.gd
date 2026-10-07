extends CanvasLayer

const OPEN_WIDTH := 0.10
const CLOSED_WIDTH := 0.5

const NIGHT := Color("14101a")
const STAGE := Color("3b2416")

const INITIAL_WAIT := 1.0
const OPEN_TIME := 1.2
const CLOSE_TIME := 1.0
const FINAL_OPEN_TIME := 1.2
const FADE_TIME := 1.0

const FADE_IN_TIME := 1.2
const FADE_OUT_TIME := 1.0

var cortina_izquierda: Cortina
var cortina_derecha: Cortina

var animando := false


class Cortina extends Control:

	const OSCURO := Color("4a0b16")
	const MEDIO := Color("7a1424")
	const CLARO := Color("9a1c30")

	const PATRON := [
		[14.0, OSCURO],
		[8.0, MEDIO],
		[8.0, CLARO],
		[8.0, MEDIO],
		[6.0, OSCURO]
	]

	var derecha := true

	func _init() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		resized.connect(queue_redraw)

	func _draw() -> void:
		var x := 0.0

		while x < size.x:
			for patron in PATRON:
				if x >= size.x:
					break

				var ancho: float = minf(
					patron[0],
					size.x - x
				)

				draw_rect(
					Rect2(x, 0, ancho, size.y),
					patron[1]
				)

				x += ancho

		for i in 12:
			var alpha := 0.4 * (1.0 - float(i) / 12.0)

			var sombra_x: float

			if derecha:
				sombra_x = size.x + i
			else:
				sombra_x = -i - 1.0

			draw_rect(
				Rect2(sombra_x, 0, 1, size.y),
				Color(0, 0, 0, alpha)
			)


func _ready() -> void:
	$MusicaMenu.stream.loop = true
	$MusicaMenu.play()
	crear_fondo()
	crear_cortinas()

	$VBoxContainer.z_index = 10
	$VBoxContainer/iniciar.pressed.connect(iniciar_juego)

	var fade := ColorRect.new()
	fade.color = Color.BLACK
	fade.modulate.a = 1.0
	fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade.z_index = 100
	add_child(fade)

	var fade_in := create_tween()
	fade_in.tween_property(
		fade,
		"modulate:a",
		0.0,
		FADE_IN_TIME
	)

	await fade_in.finished

	fade.queue_free()

	await get_tree().create_timer(INITIAL_WAIT).timeout

	abrir_telón_inicial()


func crear_fondo() -> void:

	var fondo := ColorRect.new()

	fondo.color = NIGHT
	fondo.set_anchors_preset(Control.PRESET_FULL_RECT)
	fondo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fondo.z_index = -100

	add_child(fondo)


	var gradiente := Gradient.new()

	gradiente.colors = PackedColorArray([
		Color("3a2a3f"),
		NIGHT
	])

	gradiente.offsets = PackedFloat32Array([
		0.0,
		1.0
	])


	var textura := GradientTexture2D.new()

	textura.gradient = gradiente
	textura.fill = GradientTexture2D.FILL_RADIAL
	textura.fill_from = Vector2(0.5, 0.25)
	textura.fill_to = Vector2(0.5, 1.0)

	textura.width = 512
	textura.height = 512


	var luz := TextureRect.new()

	luz.texture = textura
	luz.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	luz.stretch_mode = TextureRect.STRETCH_SCALE
	luz.set_anchors_preset(Control.PRESET_FULL_RECT)
	luz.mouse_filter = Control.MOUSE_FILTER_IGNORE
	luz.z_index = -90

	add_child(luz)


	var piso := ColorRect.new()

	piso.color = STAGE
	piso.anchor_left = 0.0
	piso.anchor_right = 1.0
	piso.anchor_top = 0.86
	piso.anchor_bottom = 1.0
	piso.mouse_filter = Control.MOUSE_FILTER_IGNORE
	piso.z_index = -80

	add_child(piso)


func crear_cortinas() -> void:

	# Inicialmente completamente cerradas

	cortina_izquierda = Cortina.new()
	cortina_izquierda.derecha = true

	cortina_izquierda.anchor_left = 0.0
	cortina_izquierda.anchor_top = 0.0
	cortina_izquierda.anchor_right = CLOSED_WIDTH
	cortina_izquierda.anchor_bottom = 1.0

	cortina_izquierda.z_index = 20

	add_child(cortina_izquierda)

	cortina_derecha = Cortina.new()
	cortina_derecha.derecha = false

	cortina_derecha.anchor_left = 1.0 - CLOSED_WIDTH
	cortina_derecha.anchor_top = 0.0
	cortina_derecha.anchor_right = 1.0
	cortina_derecha.anchor_bottom = 1.0

	cortina_derecha.z_index = 20

	add_child(cortina_derecha)


func abrir_telón_inicial() -> void:

	var ancho := get_viewport().get_visible_rect().size.x

	var desplazamiento := ancho * OPEN_WIDTH

	var tween := create_tween()

	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		cortina_izquierda,
		"offset_right",
		-desplazamiento,
		OPEN_TIME
	)

	tween.tween_property(
		cortina_derecha,
		"offset_left",
		desplazamiento,
		OPEN_TIME
	)

	await tween.finished


func iniciar_juego() -> void:
	if animando:
		return

	animando = true
	$VBoxContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var ancho := get_viewport().get_visible_rect().size.x

	# Cerrar completamente
	var cerrar := create_tween()
	cerrar.set_parallel(true)
	cerrar.set_trans(Tween.TRANS_CUBIC)
	cerrar.set_ease(Tween.EASE_IN_OUT)

	cerrar.tween_property(
		cortina_izquierda,
		"offset_right",
		0.0,
		CLOSE_TIME
	)

	cerrar.tween_property(
		cortina_derecha,
		"offset_left",
		0.0,
		CLOSE_TIME
	)

	await cerrar.finished

	# Ocultar el menú cuando el telón ya está cerrado
	$VBoxContainer.visible = false

	# Abrir completamente las cortinas
	var apertura_final := ancho * 0.48

	var abrir := create_tween()
	abrir.set_parallel(true)
	abrir.set_trans(Tween.TRANS_CUBIC)
	abrir.set_ease(Tween.EASE_IN_OUT)

	abrir.tween_property(
		cortina_izquierda,
		"offset_right",
		-apertura_final,
		1.8
	)

	abrir.tween_property(
		cortina_derecha,
		"offset_left",
		apertura_final,
		1.8
	)

	await abrir.finished

	await get_tree().create_timer(0.25).timeout

	# Fade out a negro
	var fade := ColorRect.new()
	fade.color = Color.BLACK
	fade.modulate.a = 0.0
	fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	fade.z_index = 100
	add_child(fade)

	var fade_out := create_tween()
	fade_out.set_parallel(true)

	fade_out.tween_property(
		fade,
		"modulate:a",
		1.0,
		FADE_OUT_TIME
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

	fade_out.tween_property(
		$MusicaMenu,
		"volume_db",
		-35.0,
		1.8
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	await fade_out.finished

	get_tree().change_scene_to_file("res://game.tscn")
