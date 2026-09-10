extends Control


# =========================================================
# REFERENCIAS VISUALES
# =========================================================

@onready var volver_button: Button = $VolverButton
@onready var mapa_barrio: TextureRect = $MapaBarrio

@onready var cafe_visual: TextureRect = $CafeVisual
@onready var comida_visual: TextureRect = $ComidaVisual
@onready var cafe_bistro_visual: TextureRect = $CafeBistroVisual
@onready var restaurante_visual: TextureRect = $RestauranteVisual
@onready var cadena_restaurantes_visual: TextureRect = $CadenaRestaurantesVisual
@onready var grupo_gastronomico_visual: TextureRect = $GrupoGastronomicoVisual

@onready var food_truck_visual: TextureRect = $FoodTruckVisual
@onready var catering_movil_visual: TextureRect = $CateringMovilVisual

@onready var distribuidora_visual: TextureRect = $DistribuidoraVisual
@onready var cadena_comercial_visual: TextureRect = $CadenaComercialVisual
@onready var corporacion_visual: TextureRect = $CorporacionVisual
@onready var multinacional_visual: TextureRect = $MultinacionalVisual


# =========================================================
# INICIO
# =========================================================

func _ready() -> void:
	print("")
	print("================================")
	print("🏙️ CIUDAD INICIADA")
	print("================================")
	print("")

	# -----------------------------------------------------
	# BOTÓN VOLVER
	# -----------------------------------------------------
	#
	# Antes este botón cerraba Ciudad.tscn con queue_free().
	# Ahora Ciudad forma parte permanente de Main.
	# Por eso se oculta y no recibe clics.
	# -----------------------------------------------------

	volver_button.visible = false
	volver_button.mouse_filter = Control.MOUSE_FILTER_IGNORE


	# -----------------------------------------------------
	# MAPA
	# -----------------------------------------------------

	mapa_barrio.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mapa_barrio.z_index = 0


	# -----------------------------------------------------
	# NEGOCIOS
	# -----------------------------------------------------

	cafe_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	comida_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cafe_bistro_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	restaurante_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cadena_restaurantes_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	grupo_gastronomico_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE

	food_truck_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	catering_movil_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE

	distribuidora_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cadena_comercial_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	corporacion_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
	multinacional_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE


	# -----------------------------------------------------
	# Z INDEX
	# -----------------------------------------------------

	cafe_visual.z_index = 10
	comida_visual.z_index = 10
	cafe_bistro_visual.z_index = 10
	restaurante_visual.z_index = 10
	cadena_restaurantes_visual.z_index = 10
	grupo_gastronomico_visual.z_index = 10

	food_truck_visual.z_index = 10
	catering_movil_visual.z_index = 10

	distribuidora_visual.z_index = 10
	cadena_comercial_visual.z_index = 10
	corporacion_visual.z_index = 10
	multinacional_visual.z_index = 10


	# -----------------------------------------------------
	# OCULTAR TODO AL INICIO
	# -----------------------------------------------------

	ocultar_todos_los_negocios()


# =========================================================
# OCULTAR TODOS LOS NEGOCIOS
# =========================================================

func ocultar_todos_los_negocios() -> void:
	cafe_visual.visible = false
	comida_visual.visible = false
	cafe_bistro_visual.visible = false
	restaurante_visual.visible = false
	cadena_restaurantes_visual.visible = false
	grupo_gastronomico_visual.visible = false

	food_truck_visual.visible = false
	catering_movil_visual.visible = false

	distribuidora_visual.visible = false
	cadena_comercial_visual.visible = false
	corporacion_visual.visible = false
	multinacional_visual.visible = false


# =========================================================
# RECIBIR ESTADO REAL DESDE MAIN
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
	print("☕ Cafés disponibles: ", cafes)
	print("🍔 Comidas disponibles: ", comidas)
	print("🥐 Café Bistró: ", cafes_bistro)
	print("🍽️ Restaurantes: ", restaurantes)
	print("🍴 Cadenas de Restaurantes: ", cadenas_restaurantes)
	print("👑 Grupos Gastronómicos: ", grupos_gastronomicos)
	print("🚚 Food Trucks: ", food_trucks)
	print("🍱 Catering Móvil: ", catering_moviles)
	print("🏭 Distribuidoras: ", distribuidoras)
	print("🏬 Cadenas Comerciales: ", cadenas_comerciales)
	print("🏢 Corporaciones: ", corporaciones)
	print("🌍 Multinacionales: ", multinacionales)
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
# ACTUALIZAR VISUALES DE LA CIUDAD
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

	# -----------------------------------------------------
	# REINICIAR VISUALES
	# -----------------------------------------------------

	ocultar_todos_los_negocios()


	# =====================================================
	# NEGOCIOS INDEPENDIENTES
	# =====================================================

	if cafes > 0:
		cafe_visual.visible = true

	if comidas > 0:
		comida_visual.visible = true

	if cafes_bistro > 0:
		cafe_bistro_visual.visible = true


	# =====================================================
	# TERRENO GASTRONÓMICO
	# Grupo Gastronómico > Cadena Restaurantes > Restaurante
	# =====================================================

	if grupos_gastronomicos > 0:
		grupo_gastronomico_visual.visible = true
		cadena_restaurantes_visual.visible = false
		restaurante_visual.visible = false

	elif cadenas_restaurantes > 0:
		grupo_gastronomico_visual.visible = false
		cadena_restaurantes_visual.visible = true
		restaurante_visual.visible = false

	elif restaurantes > 0:
		grupo_gastronomico_visual.visible = false
		cadena_restaurantes_visual.visible = false
		restaurante_visual.visible = true


	# =====================================================
	# FOOD TRUCK
	# =====================================================

	if food_trucks > 0:
		food_truck_visual.visible = true


	# =====================================================
	# TERRENO COMERCIAL / CORPORATIVO
	# =====================================================
	#
	# PRIORIDAD VISUAL:
	#
	# Multinacional
	#     ↓
	# Corporación
	#     ↓
	# Cadena Comercial
	#     ↓
	# Distribuidora
	#     ↓
	# Catering Móvil
	#
	# Solo decide qué imagen ocupa este terreno.
	# Los contadores reales siguen existiendo en Main.gd.
	# =====================================================

	if multinacionales > 0:
		multinacional_visual.visible = true
		corporacion_visual.visible = false
		cadena_comercial_visual.visible = false
		distribuidora_visual.visible = false
		catering_movil_visual.visible = false

	elif corporaciones > 0:
		multinacional_visual.visible = false
		corporacion_visual.visible = true
		cadena_comercial_visual.visible = false
		distribuidora_visual.visible = false
		catering_movil_visual.visible = false

	elif cadenas_comerciales > 0:
		multinacional_visual.visible = false
		corporacion_visual.visible = false
		cadena_comercial_visual.visible = true
		distribuidora_visual.visible = false
		catering_movil_visual.visible = false

	elif distribuidoras > 0:
		multinacional_visual.visible = false
		corporacion_visual.visible = false
		cadena_comercial_visual.visible = false
		distribuidora_visual.visible = true
		catering_movil_visual.visible = false

	elif catering_moviles > 0:
		multinacional_visual.visible = false
		corporacion_visual.visible = false
		cadena_comercial_visual.visible = false
		distribuidora_visual.visible = false
		catering_movil_visual.visible = true