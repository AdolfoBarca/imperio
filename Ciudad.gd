extends Control


# =========================================================
# REFERENCIAS VISUALES
# =========================================================

@onready var volver_button: Button = find_child(
	"VolverButton",
	true,
	false
) as Button

@onready var mundo_ciudad: Control = find_child(
	"MundoCiudad",
	true,
	false
) as Control

@onready var mapa_barrio: TextureRect = find_child(
	"MapaBarrio",
	true,
	false
) as TextureRect


@onready var cafe_visual: TextureRect = find_child(
	"CafeVisual",
	true,
	false
) as TextureRect

@onready var comida_visual: TextureRect = find_child(
	"ComidaVisual",
	true,
	false
) as TextureRect

@onready var cafe_bistro_visual: TextureRect = find_child(
	"CafeBistroVisual",
	true,
	false
) as TextureRect


@onready var restaurante_visual: TextureRect = find_child(
	"RestauranteVisual",
	true,
	false
) as TextureRect

@onready var cadena_restaurantes_visual: TextureRect = find_child(
	"CadenaRestaurantesVisual",
	true,
	false
) as TextureRect

@onready var grupo_gastronomico_visual: TextureRect = find_child(
	"GrupoGastronomicoVisual",
	true,
	false
) as TextureRect


@onready var food_truck_visual: TextureRect = find_child(
	"FoodTruckVisual",
	true,
	false
) as TextureRect

@onready var catering_movil_visual: TextureRect = find_child(
	"CateringMovilVisual",
	true,
	false
) as TextureRect


@onready var distribuidora_visual: TextureRect = find_child(
	"DistribuidoraVisual",
	true,
	false
) as TextureRect

@onready var cadena_comercial_visual: TextureRect = find_child(
	"CadenaComercialVisual",
	true,
	false
) as TextureRect

@onready var corporacion_visual: TextureRect = find_child(
	"CorporacionVisual",
	true,
	false
) as TextureRect

@onready var multinacional_visual: TextureRect = find_child(
	"MultinacionalVisual",
	true,
	false
) as TextureRect


# =========================================================
# MAPA
# =========================================================

const TAMANO_MAPA := Vector2(
	1672.0,
	941.0
)


# =========================================================
# CÁMARA
# =========================================================

var arrastrando: bool = false

var posicion_mouse_anterior: Vector2 = Vector2.ZERO

# =========================================================
# CONTROL TÁCTIL MÓVIL
# =========================================================
#
# Un dedo:
# - arrastra la ciudad.
#
# Dos dedos:
# - pellizco para acercar/alejar.
#
# El mouse se mantiene activo para poder seguir probando
# exactamente el mismo proyecto desde PC.
# =========================================================

var toques_activos: Dictionary = {}
var distancia_pellizco_anterior: float = 0.0

const SENSIBILIDAD_PELLIZCO: float = 0.0035


var zoom_actual: float = 0.80

const ZOOM_MINIMO_DESEADO: float = 0.75

const ZOOM_MAXIMO: float = 1.45

const PASO_ZOOM: float = 0.10

const VELOCIDAD_CAMARA: float = 1.0

# Permite desplazar la ciudad más allá del borde vertical visible.
# Esto sirve para sacar de debajo del HUD superior/inferior
# las zonas del mapa que de otra forma quedarían tapadas.
const MARGEN_VERTICAL_EXTRA: float = 220.0


# =========================================================
# ANIMACIONES
# =========================================================

const ESCALA_CONSTRUCCION_INICIAL: float = 0.30

const DURACION_CONSTRUCCION: float = 0.38

const DURACION_APARICION: float = 0.22


var tweens_construccion: Dictionary = {}

var escalas_originales: Dictionary = {}


# =========================================================
# READY
# =========================================================

func _ready() -> void:

	print("")
	print("================================")
	print("🏙️ CIUDAD INICIADA")
	print("================================")
	print("")


	if volver_button != null:

		volver_button.visible = false

		volver_button.mouse_filter = (
			Control.MOUSE_FILTER_IGNORE
		)


	if mundo_ciudad != null:

		mundo_ciudad.anchor_left = 0.0
		mundo_ciudad.anchor_top = 0.0
		mundo_ciudad.anchor_right = 0.0
		mundo_ciudad.anchor_bottom = 0.0

		mundo_ciudad.size = TAMANO_MAPA

		mundo_ciudad.pivot_offset = Vector2.ZERO

		mundo_ciudad.mouse_filter = (
			Control.MOUSE_FILTER_IGNORE
		)


	if mapa_barrio != null:

		mapa_barrio.position = Vector2.ZERO

		mapa_barrio.size = TAMANO_MAPA

		mapa_barrio.mouse_filter = (
			Control.MOUSE_FILTER_IGNORE
		)

		mapa_barrio.z_index = 0


	# =====================================================
	# CONFIGURAR EDIFICIOS
	# =====================================================

	configurar_negocio(
		cafe_visual
	)

	configurar_negocio(
		comida_visual
	)

	configurar_negocio(
		cafe_bistro_visual
	)


	configurar_negocio(
		restaurante_visual
	)

	configurar_negocio(
		cadena_restaurantes_visual
	)

	configurar_negocio(
		grupo_gastronomico_visual
	)


	configurar_negocio(
		food_truck_visual
	)

	configurar_negocio(
		catering_movil_visual
	)


	configurar_negocio(
		distribuidora_visual
	)

	configurar_negocio(
		cadena_comercial_visual
	)

	configurar_negocio(
		corporacion_visual
	)

	configurar_negocio(
		multinacional_visual
	)


	# =====================================================
	# OCULTAR TODO AL INICIO
	# =====================================================

	ocultar_todos_los_negocios()


	# =====================================================
	# ESPERAR LAYOUT
	# =====================================================

	await get_tree().process_frame
	await get_tree().process_frame


	actualizar_pivots_negocios()

	actualizar_zoom_inicial()

	centrar_ciudad()


# =========================================================
# CONFIGURAR NEGOCIO
# =========================================================

func configurar_negocio(
	nodo: Control
) -> void:

	if nodo == null:
		return


	nodo.mouse_filter = (
		Control.MOUSE_FILTER_IGNORE
	)

	nodo.z_index = 10


	# Guardamos la escala que configuraste en Godot.
	escalas_originales[nodo] = nodo.scale


	nodo.modulate.a = 1.0


# =========================================================
# OBTENER ESCALA ORIGINAL
# =========================================================

func obtener_escala_original(
	nodo: Control
) -> Vector2:

	if nodo == null:
		return Vector2.ONE


	if escalas_originales.has(nodo):

		return escalas_originales[nodo]


	return Vector2.ONE


# =========================================================
# PIVOTS
# =========================================================

func actualizar_pivots_negocios() -> void:

	actualizar_pivot_negocio(
		cafe_visual
	)

	actualizar_pivot_negocio(
		comida_visual
	)

	actualizar_pivot_negocio(
		cafe_bistro_visual
	)


	actualizar_pivot_negocio(
		restaurante_visual
	)

	actualizar_pivot_negocio(
		cadena_restaurantes_visual
	)

	actualizar_pivot_negocio(
		grupo_gastronomico_visual
	)


	actualizar_pivot_negocio(
		food_truck_visual
	)

	actualizar_pivot_negocio(
		catering_movil_visual
	)


	actualizar_pivot_negocio(
		distribuidora_visual
	)

	actualizar_pivot_negocio(
		cadena_comercial_visual
	)

	actualizar_pivot_negocio(
		corporacion_visual
	)

	actualizar_pivot_negocio(
		multinacional_visual
	)


func actualizar_pivot_negocio(
	nodo: Control
) -> void:

	if nodo == null:
		return


	nodo.pivot_offset = (
		nodo.size / 2.0
	)


# =========================================================
# ANIMACIONES
# =========================================================

func cancelar_animacion(
	nodo: Control
) -> void:

	if nodo == null:
		return


	if not tweens_construccion.has(nodo):
		return


	var tween_anterior = (
		tweens_construccion[nodo]
	)


	if (
		tween_anterior != null
		and tween_anterior.is_valid()
	):

		tween_anterior.kill()


	tweens_construccion.erase(
		nodo
	)


func restaurar_estado_visual(
	nodo: Control
) -> void:

	if nodo == null:
		return


	cancelar_animacion(
		nodo
	)


	nodo.scale = (
		obtener_escala_original(nodo)
	)

	nodo.modulate.a = 1.0


func mostrar_negocio(
	nodo: Control,
	estaba_visible_antes: bool
) -> void:

	if nodo == null:
		return


	nodo.visible = true


	if estaba_visible_antes:

		restaurar_estado_visual(
			nodo
		)

		return


	animar_construccion(
		nodo
	)


func animar_construccion(
	nodo: Control
) -> void:

	if nodo == null:
		return


	cancelar_animacion(
		nodo
	)


	var escala_final: Vector2 = (
		obtener_escala_original(nodo)
	)


	nodo.pivot_offset = (
		nodo.size / 2.0
	)


	nodo.scale = (
		escala_final
		* ESCALA_CONSTRUCCION_INICIAL
	)


	nodo.modulate.a = 0.0


	var tween: Tween = create_tween()


	tweens_construccion[nodo] = tween


	tween.set_parallel(
		true
	)


	tween.tween_property(
		nodo,
		"scale",
		escala_final,
		DURACION_CONSTRUCCION
	).set_trans(
		Tween.TRANS_BACK
	).set_ease(
		Tween.EASE_OUT
	)


	tween.tween_property(
		nodo,
		"modulate:a",
		1.0,
		DURACION_APARICION
	).set_trans(
		Tween.TRANS_QUAD
	).set_ease(
		Tween.EASE_OUT
	)


	print(
		"🏗️ CONSTRUCCIÓN VISUAL: ",
		nodo.name
	)


# =========================================================
# ZOOM MÍNIMO
# =========================================================

func obtener_zoom_minimo_seguro() -> float:

	var pantalla: Vector2 = (
		get_viewport_rect().size
	)


	if (
		pantalla.x <= 0.0
		or pantalla.y <= 0.0
	):

		return ZOOM_MINIMO_DESEADO


	var zoom_necesario_x: float = (
		pantalla.x
		/ TAMANO_MAPA.x
	)


	var zoom_necesario_y: float = (
		pantalla.y
		/ TAMANO_MAPA.y
	)


	var zoom_para_cubrir_pantalla: float = max(
		zoom_necesario_x,
		zoom_necesario_y
	)


	var zoom_minimo_seguro: float = max(
		ZOOM_MINIMO_DESEADO,
		zoom_para_cubrir_pantalla
	)


	return min(
		zoom_minimo_seguro,
		ZOOM_MAXIMO
	)


# =========================================================
# ZOOM INICIAL
# =========================================================

func actualizar_zoom_inicial() -> void:

	if mundo_ciudad == null:
		return


	var zoom_minimo_seguro: float = (
		obtener_zoom_minimo_seguro()
	)


	zoom_actual = clamp(
		zoom_actual,
		zoom_minimo_seguro,
		ZOOM_MAXIMO
	)


	mundo_ciudad.scale = Vector2(
		zoom_actual,
		zoom_actual
	)


	print(
		"🔎 ZOOM INICIAL: ",
		zoom_actual
	)

	print(
		"🔒 ZOOM MÍNIMO SEGURO: ",
		zoom_minimo_seguro
	)


# =========================================================
# CENTRAR CIUDAD
# =========================================================

func centrar_ciudad() -> void:

	if mundo_ciudad == null:
		return


	var pantalla: Vector2 = (
		get_viewport_rect().size
	)


	var tamano_escalado: Vector2 = (
		TAMANO_MAPA
		* zoom_actual
	)


	var posicion_global_centrada := Vector2(

		(
			pantalla.x
			- tamano_escalado.x
		) / 2.0,

		(
			pantalla.y
			- tamano_escalado.y
		) / 2.0
	)


	mundo_ciudad.global_position = (
		posicion_global_centrada
	)


	aplicar_limites()


	print(
		"🎯 MAPA CENTRADO GLOBAL: ",
		mundo_ciudad.global_position
	)


# =========================================================
# INPUT
# =========================================================

func _input(
	event: InputEvent
) -> void:

	if mundo_ciudad == null:
		return

	# Si el puntero está dentro del panel de FUSIONES, la ciudad no debe
	# reaccionar a rueda, clic, arrastre ni toque. Fuera del panel,
	# conservamos exactamente el control original del mapa.
	var fusiones_panel := get_tree().root.find_child("FusionesPanel", true, false) as Control
	if fusiones_panel != null and fusiones_panel.visible:
		var posicion_evento := Vector2.ZERO
		var evento_con_posicion := false

		if event is InputEventMouse:
			posicion_evento = event.position
			evento_con_posicion = true
		elif event is InputEventScreenTouch:
			posicion_evento = event.position
			evento_con_posicion = true
		elif event is InputEventScreenDrag:
			posicion_evento = event.position
			evento_con_posicion = true

		if evento_con_posicion and fusiones_panel.get_global_rect().has_point(posicion_evento):
			arrastrando = false
			return


	# =====================================================
	# TÁCTIL: TOCAR / SOLTAR
	# =====================================================

	if event is InputEventScreenTouch:

		if event.pressed:

			toques_activos[event.index] = event.position

		else:

			toques_activos.erase(event.index)


		if toques_activos.size() < 2:

			distancia_pellizco_anterior = 0.0

		else:

			distancia_pellizco_anterior = (
				obtener_distancia_entre_dos_toques()
			)

		return


	# =====================================================
	# TÁCTIL: ARRASTRE / PELLIZCO
	# =====================================================

	if event is InputEventScreenDrag:

		var posicion_anterior_dedo: Vector2 = (
			event.position
			- event.relative
		)

		toques_activos[event.index] = event.position


		if toques_activos.size() == 1:

			mundo_ciudad.global_position += (
				event.relative
				* VELOCIDAD_CAMARA
			)

			aplicar_limites()

			return


		if toques_activos.size() >= 2:

			var distancia_actual: float = (
				obtener_distancia_entre_dos_toques()
			)

			if distancia_pellizco_anterior <= 0.0:

				distancia_pellizco_anterior = (
					distancia_actual
				)

				return


			var diferencia_distancia: float = (
				distancia_actual
				- distancia_pellizco_anterior
			)

			var centro_pellizco: Vector2 = (
				obtener_centro_entre_dos_toques()
			)


			cambiar_zoom_en_punto(
				diferencia_distancia
				* SENSIBILIDAD_PELLIZCO,
				centro_pellizco
			)


			distancia_pellizco_anterior = (
				distancia_actual
			)

			return


	# =====================================================
	# MOUSE: PC
	# =====================================================

	if event is InputEventMouseButton:


		if (
			event.button_index
			== MOUSE_BUTTON_LEFT
		):

			if event.pressed:

				arrastrando = true

				posicion_mouse_anterior = (
					event.position
				)

			else:

				arrastrando = false


		elif (
			event.button_index
			== MOUSE_BUTTON_WHEEL_UP
			and event.pressed
		):

			cambiar_zoom(
				PASO_ZOOM
			)


		elif (
			event.button_index
			== MOUSE_BUTTON_WHEEL_DOWN
			and event.pressed
		):

			cambiar_zoom(
				-PASO_ZOOM
			)


	if (
		event is InputEventMouseMotion
		and arrastrando
	):

		var movimiento_mouse: Vector2 = (
			event.position
			- posicion_mouse_anterior
		)


		mundo_ciudad.global_position += (
			movimiento_mouse
			* VELOCIDAD_CAMARA
		)


		posicion_mouse_anterior = (
			event.position
		)


		aplicar_limites()


# =========================================================
# UTILIDADES TÁCTILES
# =========================================================

func obtener_dos_indices_de_toque() -> Array:

	var indices: Array = (
		toques_activos.keys()
	)

	indices.sort()

	if indices.size() > 2:

		indices.resize(2)

	return indices


func obtener_distancia_entre_dos_toques() -> float:

	var indices: Array = (
		obtener_dos_indices_de_toque()
	)

	if indices.size() < 2:
		return 0.0


	var posicion_a: Vector2 = (
		toques_activos[indices[0]]
	)

	var posicion_b: Vector2 = (
		toques_activos[indices[1]]
	)


	return posicion_a.distance_to(
		posicion_b
	)


func obtener_centro_entre_dos_toques() -> Vector2:

	var indices: Array = (
		obtener_dos_indices_de_toque()
	)

	if indices.size() < 2:

		return (
			get_viewport_rect().size
			/ 2.0
		)


	var posicion_a: Vector2 = (
		toques_activos[indices[0]]
	)

	var posicion_b: Vector2 = (
		toques_activos[indices[1]]
	)


	return (
		posicion_a
		+ posicion_b
	) / 2.0


# =========================================================
# CAMBIAR ZOOM
# =========================================================

func cambiar_zoom(
	cambio: float
) -> void:

	cambiar_zoom_en_punto(
		cambio,
		get_viewport().get_mouse_position()
	)


func cambiar_zoom_en_punto(
	cambio: float,
	punto_pantalla: Vector2
) -> void:

	if mundo_ciudad == null:
		return


	var zoom_anterior: float = (
		zoom_actual
	)


	var zoom_minimo_seguro: float = (
		obtener_zoom_minimo_seguro()
	)


	zoom_actual = clamp(
		zoom_actual + cambio,
		zoom_minimo_seguro,
		ZOOM_MAXIMO
	)


	if is_equal_approx(
		zoom_anterior,
		zoom_actual
	):

		return


	var punto_mapa: Vector2 = (
		(
			punto_pantalla
			- mundo_ciudad.global_position
		)
		/ zoom_anterior
	)


	mundo_ciudad.scale = Vector2(
		zoom_actual,
		zoom_actual
	)


	mundo_ciudad.global_position = (
		punto_pantalla
		- punto_mapa
		* zoom_actual
	)


	aplicar_limites()


	print(
		"🔎 ZOOM: ",
		zoom_actual
	)


# =========================================================
# LÍMITES
# =========================================================

func aplicar_limites() -> void:

	if mundo_ciudad == null:
		return


	var pantalla: Vector2 = (
		get_viewport_rect().size
	)


	var tamano_escalado: Vector2 = (
		TAMANO_MAPA
		* zoom_actual
	)


	var posicion_global: Vector2 = (
		mundo_ciudad.global_position
	)


	# =====================================================
	# HORIZONTAL
	# =====================================================

	if tamano_escalado.x >= pantalla.x:

		var minimo_x: float = (
			pantalla.x
			- tamano_escalado.x
		)

		var maximo_x: float = 0.0


		posicion_global.x = clamp(
			posicion_global.x,
			minimo_x,
			maximo_x
		)

	else:

		posicion_global.x = (
			pantalla.x
			- tamano_escalado.x
		) / 2.0


	# =====================================================
	# VERTICAL
	# =====================================================
	#
	# Permitimos un margen adicional arriba y abajo.
	# Así el jugador puede llevar cualquier parte de la
	# ciudad al centro de la pantalla aunque el HUD tape
	# una franja superior o inferior.
	# =====================================================

	if tamano_escalado.y >= pantalla.y:

		var minimo_y: float = (
			pantalla.y
			- tamano_escalado.y
			- MARGEN_VERTICAL_EXTRA
		)

		# No dejamos bajar el mapa más allá del borde superior.
		# Así nunca aparece fondo gris arriba.
		var maximo_y: float = 0.0


		posicion_global.y = clamp(
			posicion_global.y,
			minimo_y,
			maximo_y
		)

	else:

		var posicion_centrada_y: float = (
			pantalla.y
			- tamano_escalado.y
		) / 2.0

		var minimo_y: float = (
			posicion_centrada_y
			- MARGEN_VERTICAL_EXTRA
		)

		var maximo_y: float = (
			posicion_centrada_y
		)


		posicion_global.y = clamp(
			posicion_global.y,
			minimo_y,
			maximo_y
		)


	mundo_ciudad.global_position = (
		posicion_global
	)


# =========================================================
# ESTABA VISIBLE
# =========================================================

func estaba_visible(
	nodo: Control
) -> bool:

	if nodo == null:
		return false


	return nodo.visible


# =========================================================
# OCULTAR NEGOCIO
# =========================================================

func ocultar_negocio(
	nodo: Control
) -> void:

	if nodo == null:
		return


	cancelar_animacion(
		nodo
	)


	nodo.scale = (
		obtener_escala_original(nodo)
	)

	nodo.modulate.a = 1.0

	nodo.visible = false


# =========================================================
# OCULTAR TODOS
# =========================================================

func ocultar_todos_los_negocios() -> void:

	ocultar_negocio(
		cafe_visual
	)

	ocultar_negocio(
		comida_visual
	)

	ocultar_negocio(
		cafe_bistro_visual
	)


	ocultar_negocio(
		restaurante_visual
	)

	ocultar_negocio(
		cadena_restaurantes_visual
	)

	ocultar_negocio(
		grupo_gastronomico_visual
	)


	ocultar_negocio(
		food_truck_visual
	)

	ocultar_negocio(
		catering_movil_visual
	)


	ocultar_negocio(
		distribuidora_visual
	)

	ocultar_negocio(
		cadena_comercial_visual
	)

	ocultar_negocio(
		corporacion_visual
	)

	ocultar_negocio(
		multinacional_visual
	)


# =========================================================
# CONFIGURAR ESTADO DE CIUDAD
# =========================================================

func configurar(
	cafes: int,
	comidas: int,
	cafes_bistro: int,
	restaurantes: int,
	cadenas_restaurantes: int,
	grupos_gastronomicos: int,
	food_trucks: int,
	catering_moviles: int,
	distribuidoras: int,
	cadenas_comerciales: int,
	corporaciones: int,
	multinacionales: int
) -> void:

	print("")
	print("================================")
	print("🏙️ CONFIGURANDO CIUDAD")

	print(
		"☕ Cafés: ",
		cafes
	)

	print(
		"🍔 Comidas: ",
		comidas
	)

	print(
		"🥐 Café Bistró: ",
		cafes_bistro
	)

	print(
		"🍽️ Restaurantes: ",
		restaurantes
	)

	print(
		"🍴 Cadenas Restaurantes: ",
		cadenas_restaurantes
	)

	print(
		"👑 Grupos Gastronómicos: ",
		grupos_gastronomicos
	)

	print(
		"🚚 Food Trucks: ",
		food_trucks
	)

	print(
		"🍱 Catering Móvil: ",
		catering_moviles
	)

	print(
		"🏭 Distribuidoras: ",
		distribuidoras
	)

	print(
		"🏬 Cadenas Comerciales: ",
		cadenas_comerciales
	)

	print(
		"🏢 Corporaciones: ",
		corporaciones
	)

	print(
		"🌍 Multinacionales: ",
		multinacionales
	)

	print("================================")
	print("")


	actualizar_visuales(
		cafes,
		comidas,
		cafes_bistro,
		restaurantes,
		cadenas_restaurantes,
		grupos_gastronomicos,
		food_trucks,
		catering_moviles,
		distribuidoras,
		cadenas_comerciales,
		corporaciones,
		multinacionales
	)


# =========================================================
# ACTUALIZAR VISUALES
# =========================================================

func actualizar_visuales(
	cafes: int,
	comidas: int,
	cafes_bistro: int,
	restaurantes: int,
	cadenas_restaurantes: int,
	grupos_gastronomicos: int,
	food_trucks: int,
	catering_moviles: int,
	distribuidoras: int,
	cadenas_comerciales: int,
	corporaciones: int,
	multinacionales: int
) -> void:


	# =====================================================
	# GUARDAR QUÉ ESTABA VISIBLE
	# =====================================================

	var cafe_estaba_visible: bool = (
		estaba_visible(
			cafe_visual
		)
	)

	var comida_estaba_visible: bool = (
		estaba_visible(
			comida_visual
		)
	)

	var bistro_estaba_visible: bool = (
		estaba_visible(
			cafe_bistro_visual
		)
	)


	var restaurante_estaba_visible: bool = (
		estaba_visible(
			restaurante_visual
		)
	)

	var cadena_restaurantes_estaba_visible: bool = (
		estaba_visible(
			cadena_restaurantes_visual
		)
	)

	var grupo_gastronomico_estaba_visible: bool = (
		estaba_visible(
			grupo_gastronomico_visual
		)
	)


	var food_truck_estaba_visible: bool = (
		estaba_visible(
			food_truck_visual
		)
	)

	var catering_estaba_visible: bool = (
		estaba_visible(
			catering_movil_visual
		)
	)

	var distribuidora_estaba_visible: bool = (
		estaba_visible(
			distribuidora_visual
		)
	)

	var cadena_comercial_estaba_visible: bool = (
		estaba_visible(
			cadena_comercial_visual
		)
	)

	var corporacion_estaba_visible: bool = (
		estaba_visible(
			corporacion_visual
		)
	)

	var multinacional_estaba_visible: bool = (
		estaba_visible(
			multinacional_visual
		)
	)


	# =====================================================
	# OCULTAR PARA RECALCULAR
	# =====================================================

	ocultar_todos_los_negocios()


	# =====================================================
	# LOTE CAFÉ / BISTRÓ
	# =====================================================
	#
	# Bistró tiene prioridad visual.
	#
	# Si existe Bistró, no mostramos Café debajo.
	#
	# IMPORTANTE:
	# el Café sigue existiendo en la lógica.
	# =====================================================

	if cafes_bistro > 0:

		if cafe_bistro_visual != null:

			mostrar_negocio(
				cafe_bistro_visual,
				bistro_estaba_visible
			)

	elif cafes > 0:

		if cafe_visual != null:

			mostrar_negocio(
				cafe_visual,
				cafe_estaba_visible
			)


	# =====================================================
	# COMIDA
	# =====================================================
	#
	# Comida tiene su propio lote.
	#
	# Por eso, aunque exista Bistró, una Comida nueva
	# SÍ debe verse.
	# =====================================================

	if comidas > 0:

		if comida_visual != null:

			mostrar_negocio(
				comida_visual,
				comida_estaba_visible
			)


	# =====================================================
	# RUTA GASTRONÓMICA
	# =====================================================
	#
	# Grupo Gastronómico
	#       >
	# Cadena Restaurantes
	#       >
	# Restaurante
	# =====================================================

	if grupos_gastronomicos > 0:

		if grupo_gastronomico_visual != null:

			mostrar_negocio(
				grupo_gastronomico_visual,
				grupo_gastronomico_estaba_visible
			)


	elif cadenas_restaurantes > 0:

		if cadena_restaurantes_visual != null:

			mostrar_negocio(
				cadena_restaurantes_visual,
				cadena_restaurantes_estaba_visible
			)


	elif restaurantes > 0:

		if restaurante_visual != null:

			mostrar_negocio(
				restaurante_visual,
				restaurante_estaba_visible
			)


	# =====================================================
	# RUTA COMERCIAL
	# =====================================================
	#
	# Todos estos visuales comparten prácticamente
	# el mismo terreno en Ciudad.tscn:
	#
	# Food Truck
	# ↓
	# Catering Móvil
	# ↓
	# Distribuidora
	# ↓
	# Cadena Comercial
	# ↓
	# Corporación
	# ↓
	# Multinacional
	#
	# Solo mostramos la etapa más avanzada.
	# =====================================================

	if multinacionales > 0:

		if multinacional_visual != null:

			mostrar_negocio(
				multinacional_visual,
				multinacional_estaba_visible
			)


	elif corporaciones > 0:

		if corporacion_visual != null:

			mostrar_negocio(
				corporacion_visual,
				corporacion_estaba_visible
			)


	elif cadenas_comerciales > 0:

		if cadena_comercial_visual != null:

			mostrar_negocio(
				cadena_comercial_visual,
				cadena_comercial_estaba_visible
			)


	elif distribuidoras > 0:

		if distribuidora_visual != null:

			mostrar_negocio(
				distribuidora_visual,
				distribuidora_estaba_visible
			)


	elif catering_moviles > 0:

		if catering_movil_visual != null:

			mostrar_negocio(
				catering_movil_visual,
				catering_estaba_visible
			)


	elif food_trucks > 0:

		if food_truck_visual != null:

			mostrar_negocio(
				food_truck_visual,
				food_truck_estaba_visible
			)