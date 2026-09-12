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


# La ciudad ahora inicia más alejada.
var zoom_actual: float = 0.80


# Zoom mínimo deseado.
# Si este valor dejara ver fondo gris, el código
# calcula automáticamente un mínimo seguro mayor.
const ZOOM_MINIMO_DESEADO: float = 0.75


# Zoom máximo.
const ZOOM_MAXIMO: float = 1.45


# Cambio de zoom por cada paso de la rueda.
const PASO_ZOOM: float = 0.10


const VELOCIDAD_CAMARA: float = 1.0


# =========================================================
# INICIO
# =========================================================

func _ready() -> void:

	print("")
	print("================================")
	print("🏙️ CIUDAD INICIADA")
	print("================================")
	print("")


	# =====================================================
	# BOTÓN VOLVER
	# =====================================================

	if volver_button != null:

		volver_button.visible = false

		volver_button.mouse_filter = (
			Control.MOUSE_FILTER_IGNORE
		)


	# =====================================================
	# MUNDO CIUDAD
	# =====================================================

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


	# =====================================================
	# MAPA
	# =====================================================

	if mapa_barrio != null:

		mapa_barrio.position = Vector2.ZERO

		mapa_barrio.size = TAMANO_MAPA

		mapa_barrio.mouse_filter = (
			Control.MOUSE_FILTER_IGNORE
		)

		mapa_barrio.z_index = 0


	# =====================================================
	# EDIFICIOS
	# =====================================================

	configurar_negocio(cafe_visual)
	configurar_negocio(comida_visual)
	configurar_negocio(cafe_bistro_visual)

	configurar_negocio(restaurante_visual)
	configurar_negocio(cadena_restaurantes_visual)
	configurar_negocio(grupo_gastronomico_visual)

	configurar_negocio(food_truck_visual)
	configurar_negocio(catering_movil_visual)

	configurar_negocio(distribuidora_visual)
	configurar_negocio(cadena_comercial_visual)
	configurar_negocio(corporacion_visual)
	configurar_negocio(multinacional_visual)


	# =====================================================
	# OCULTAR EDIFICIOS
	# =====================================================

	ocultar_todos_los_negocios()


	# =====================================================
	# ESPERAR A QUE MAIN TERMINE SU LAYOUT
	# =====================================================

	await get_tree().process_frame

	await get_tree().process_frame


	# =====================================================
	# PREPARAR ZOOM INICIAL
	# =====================================================

	actualizar_zoom_inicial()


	# =====================================================
	# CENTRAR EL MAPA
	# =====================================================

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


# =========================================================
# ZOOM MÍNIMO SEGURO
# =========================================================
#
# Calcula cuánto puede alejarse la ciudad sin que
# aparezca fondo gris.
#
# Si 0.75 funciona, permitirá llegar a 0.75.
#
# Si la resolución necesita más zoom para cubrir
# toda la pantalla, el mínimo aumentará automáticamente.
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
# PREPARAR ZOOM INICIAL
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


	if event is InputEventMouseButton:


		# -------------------------------------------------
		# CLIC IZQUIERDO
		# -------------------------------------------------

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


		# -------------------------------------------------
		# ZOOM +
		# -------------------------------------------------

		elif (
			event.button_index
			== MOUSE_BUTTON_WHEEL_UP
			and event.pressed
		):

			cambiar_zoom(
				PASO_ZOOM
			)


		# -------------------------------------------------
		# ZOOM -
		# -------------------------------------------------

		elif (
			event.button_index
			== MOUSE_BUTTON_WHEEL_DOWN
			and event.pressed
		):

			cambiar_zoom(
				-PASO_ZOOM
			)


	# =====================================================
	# ARRASTRAR CIUDAD
	# =====================================================

	if (
		event is InputEventMouseMotion
		and arrastrando
	):

		var movimiento_mouse: Vector2 = (
			event.position
			- posicion_mouse_anterior
		)


		mundo_ciudad.global_position -= (
			movimiento_mouse
			* VELOCIDAD_CAMARA
		)


		posicion_mouse_anterior = (
			event.position
		)


		aplicar_limites()


# =========================================================
# ZOOM
# =========================================================

func cambiar_zoom(
	cambio: float
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


	# =====================================================
	# POSICIÓN DEL MOUSE
	# =====================================================

	var mouse: Vector2 = (
		get_viewport().get_mouse_position()
	)


	# =====================================================
	# PUNTO DEL MAPA BAJO EL CURSOR
	# =====================================================

	var punto_mapa: Vector2 = (
		(
			mouse
			- mundo_ciudad.global_position
		)
		/ zoom_anterior
	)


	# =====================================================
	# APLICAR ESCALA
	# =====================================================

	mundo_ciudad.scale = Vector2(
		zoom_actual,
		zoom_actual
	)


	# =====================================================
	# CONSERVAR PUNTO DEL CURSOR
	# =====================================================

	mundo_ciudad.global_position = (
		mouse
		- punto_mapa
		* zoom_actual
	)


	aplicar_limites()


	print(
		"🔎 ZOOM: ",
		zoom_actual
	)


# =========================================================
# LÍMITES AUTOMÁTICOS
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

	if tamano_escalado.y >= pantalla.y:

		var minimo_y: float = (
			pantalla.y
			- tamano_escalado.y
		)

		var maximo_y: float = 0.0


		posicion_global.y = clamp(
			posicion_global.y,
			minimo_y,
			maximo_y
		)

	else:

		posicion_global.y = (
			pantalla.y
			- tamano_escalado.y
		) / 2.0


	mundo_ciudad.global_position = (
		posicion_global
	)


# =========================================================
# OCULTAR TODOS LOS NEGOCIOS
# =========================================================

func ocultar_todos_los_negocios() -> void:

	if cafe_visual != null:
		cafe_visual.visible = false

	if comida_visual != null:
		comida_visual.visible = false

	if cafe_bistro_visual != null:
		cafe_bistro_visual.visible = false


	if restaurante_visual != null:
		restaurante_visual.visible = false

	if cadena_restaurantes_visual != null:
		cadena_restaurantes_visual.visible = false

	if grupo_gastronomico_visual != null:
		grupo_gastronomico_visual.visible = false


	if food_truck_visual != null:
		food_truck_visual.visible = false

	if catering_movil_visual != null:
		catering_movil_visual.visible = false


	if distribuidora_visual != null:
		distribuidora_visual.visible = false

	if cadena_comercial_visual != null:
		cadena_comercial_visual.visible = false

	if corporacion_visual != null:
		corporacion_visual.visible = false

	if multinacional_visual != null:
		multinacional_visual.visible = false


# =========================================================
# RECIBIR ESTADO DESDE MAIN
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

	print("☕ Cafés: ", cafes)
	print("🍔 Comidas: ", comidas)
	print("🥐 Café Bistró: ", cafes_bistro)

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

	ocultar_todos_los_negocios()


	# =====================================================
	# CAFÉ
	# =====================================================

	if (
		cafes > 0
		and cafe_visual != null
	):

		cafe_visual.visible = true


	# =====================================================
	# COMIDA
	# =====================================================

	if (
		comidas > 0
		and comida_visual != null
	):

		comida_visual.visible = true


	# =====================================================
	# CAFÉ BISTRÓ
	# =====================================================

	if (
		cafes_bistro > 0
		and cafe_bistro_visual != null
	):

		cafe_bistro_visual.visible = true


	# =====================================================
	# RUTA GASTRONÓMICA
	# =====================================================

	if grupos_gastronomicos > 0:

		if grupo_gastronomico_visual != null:
			grupo_gastronomico_visual.visible = true


	elif cadenas_restaurantes > 0:

		if cadena_restaurantes_visual != null:
			cadena_restaurantes_visual.visible = true


	elif restaurantes > 0:

		if restaurante_visual != null:
			restaurante_visual.visible = true


	# =====================================================
	# FOOD TRUCK
	# =====================================================

	if (
		food_trucks > 0
		and food_truck_visual != null
	):

		food_truck_visual.visible = true


	# =====================================================
	# RUTA COMERCIAL / CORPORATIVA
	# =====================================================

	if multinacionales > 0:

		if multinacional_visual != null:
			multinacional_visual.visible = true


	elif corporaciones > 0:

		if corporacion_visual != null:
			corporacion_visual.visible = true


	elif cadenas_comerciales > 0:

		if cadena_comercial_visual != null:
			cadena_comercial_visual.visible = true


	elif distribuidoras > 0:

		if distribuidora_visual != null:
			distribuidora_visual.visible = true


	elif catering_moviles > 0:

		if catering_movil_visual != null:
			catering_movil_visual.visible = true