extends Control


# =========================================================
# CONFIGURACIÓN GENERAL
# =========================================================

const RONDA_MAXIMA: int = 30
const OBJETIVO_DINERO: int = 1_000_000
const ACCIONES_POR_RONDA: int = 5
const MAX_RONDAS_CON_DINERO_NEGATIVO: int = 3

# Hitos empresariales v8
const META_HITO_1: int = 3
const META_HITO_2: int = 6
const META_HITO_3: int = 9

# Los hitos 3/6/9 ahora crean una progresión permanente.
# El primer hito también puede dar una recompensa inmediata.
const VENTAS_MEJORADAS_HITO_REVENTA: int = 2

const COSTO_CAFE: int = 30
const COSTO_COMIDA: int = 50
const COSTO_VEHICULO: int = 40
const COSTO_REVENTA: int = 25

const INGRESO_CAFE: int = 10
const INGRESO_COMIDA: int = 15
const INGRESO_BISTRO: int = 45
const INGRESO_FOOD_TRUCK: int = 90
const INGRESO_CATERING: int = 180
const INGRESO_RESTAURANTE: int = 600
const INGRESO_CADENA_RESTAURANTES: int = 6000
const INGRESO_GRUPO_GASTRONOMICO: int = 25000
const INGRESO_DISTRIBUIDORA: int = 200
const INGRESO_CADENA: int = 900
const INGRESO_CORPORACION: int = 4000
const INGRESO_MULTINACIONAL: int = 30000

# Oportunidades empresariales v8.4.1
const FRECUENCIA_OPORTUNIDADES: int = 3

# Campaña Viral: inversión fuerte vs. campaña austera.
const COSTO_CAMPANA_LOCAL: int = 5000
const COSTO_CAMPANA_AUSTERA: int = 2000

# Local Premium: pago fuerte corto vs. alquiler por ronda.
const COSTO_LOCAL_PREMIUM: int = 20000
const COSTO_ALQUILER_LOCAL_PREMIUM_RONDA: int = 5000

# Contrato Internacional: opción segura vs. opción de riesgo.
const COSTO_CONTRATO_INTERNACIONAL: int = 20000
const PAGO_CONTRATO_INTERNACIONAL: int = 65000
const COSTO_CONTRATO_RIESGOSO: int = 12000
const PAGO_CONTRATO_RIESGOSO: int = 100000
const PROBABILIDAD_CONTRATO_RIESGOSO: int = 55

# Inversionista: capital a cambio de ingresos vs. préstamo con vencimiento.
const CAPITAL_INVERSIONISTA: int = 100000
const CAPITAL_PRESTAMO: int = 60000
const PAGO_PRESTAMO: int = 85000



# =========================================================
# ESTADO DE LA PARTIDA
# =========================================================

var dinero: int = 100
var ronda: int = 1
var partida_terminada: bool = false
var rondas_consecutivas_en_negativo: int = 0

var acciones_restantes: int = ACCIONES_POR_RONDA

# Oportunidades v8.4.1: cada aparición ofrece dos caminos con costos y riesgos distintos.
var oportunidad_actual: String = ""
var ultima_ronda_oportunidad: int = 0
var oportunidades_usadas: Array[String] = []

var campana_local_rondas: int = 0
var campana_local_multiplicador: float = 1.0

var local_premium_rondas: int = 0
var local_premium_multiplicador: float = 1.0
var local_premium_alquiler_por_ronda: int = 0

var inversionista_rondas: int = 0
var prestamo_rondas: int = 0
var prestamo_pago_pendiente: int = 0
var prestamo_ronda_inicio: int = 0

var contrato_internacional_rondas: int = 0
var contrato_internacional_pago: int = 0
var contrato_internacional_riesgoso: bool = false

var oportunidad_panel: PanelContainer
var oportunidad_titulo: Label
var oportunidad_descripcion: Label
var oportunidad_aceptar_button: Button
var oportunidad_rechazar_button: Button


# =========================================================
# SISTEMA DE MAZO Y MANO
# =========================================================

const CARTAS_MANO_INICIAL: int = 5
const CARTAS_ROBADAS_POR_RONDA: int = 2
const MAX_CARTAS_MANO: int = 5
const ENERGIA_MAXIMA: int = 5

const COSTO_HABILIDAD_CAFE: int = 2
const COSTO_HABILIDAD_COMIDA: int = 2
const COSTO_HABILIDAD_VEHICULO: int = 3
const COSTO_HABILIDAD_REVENTA: int = 2

var mazo_cartas: Array[String] = []
var mano_cartas: Array[String] = []
var pila_descarte: Array[String] = []

var energia: int = 0

# Habilidades activas de la ronda
var hora_pico_activa: bool = false
var delivery_activo: bool = false
var logistica_activa: bool = false
var negociacion_activa: bool = false
# Delivery dura la ronda actual y puede dejar una segunda ronda bonificada.
var delivery_rondas_restantes: int = 0

const ESTRELLAS_CARTAS: Dictionary = {
	"cafe": 1,
	"comida": 1,
	"vehiculo": 2,
	"reventa": 1
}


# =========================================================
# MENÚ CONTEXTUAL DE CARTAS
# =========================================================

var carta_menu_actual: String = ""

var popup_carta: PopupPanel
var popup_titulo: Label
var popup_descripcion: Label
var popup_estado_energia: Label
var popup_usar_habilidad_button: Button
var popup_descartar_button: Button


# =========================================================
# MENSAJE VISUAL DE HABILIDADES
# =========================================================

var mensaje_efecto_panel: PanelContainer
var mensaje_efecto_titulo: Label
var mensaje_efecto_descripcion: Label
var mensaje_efecto_tween: Tween
var avisos_placeholder: Label


# =========================================================
# PANEL PERMANENTE DE EFECTOS ACTIVOS
# =========================================================

var efectos_activos_panel: PanelContainer
var efectos_activos_label: Label


# =========================================================
# ESTADO VISUAL DE LA RONDA
# =========================================================

# Los antiguos eventos automáticos (Boom/Recesión) fueron retirados.
# Ahora los modificadores especiales solo se activan mediante cartas.


# =========================================================
# NEGOCIOS Y RECURSOS
# =========================================================

var cafes: int = 0
var comidas: int = 0
var vehiculos: int = 0
var reventas: int = 0

var cafes_bistro: int = 0
var food_trucks: int = 0
var catering_moviles: int = 0

var restaurantes: int = 0
var cadenas_restaurantes: int = 0
var grupos_gastronomicos: int = 0

var distribuidoras: int = 0
var cadenas_comerciales: int = 0
var corporaciones: int = 0
var multinacionales: int = 0


# =========================================================
# HITOS EMPRESARIALES v8.1 — PROGRESIÓN 3 / 6 / 9
# =========================================================

# Progreso acumulado: cuenta cartas COMPRADAS durante toda la partida,
# aunque después se consuman en fusiones.
var cafes_comprados_total: int = 0
var comidas_compradas_total: int = 0
var vehiculos_comprados_total: int = 0
var reventas_compradas_total: int = 0

# Nivel 0 = ningún hito, 1 = 3 cartas, 2 = 6 cartas, 3 = 9 cartas.
var hito_cafe_nivel: int = 0
var hito_comida_nivel: int = 0
var hito_vehiculo_nivel: int = 0
var hito_reventa_nivel: int = 0

# Recompensas pendientes de Reventa.
var ventas_hito_reventa_restantes: int = 0
var minimo_venta_hito_reventa: int = 0

# =========================================================
# DESCUBRIMIENTOS
# =========================================================

var bistro_descubierto: bool = false
var food_truck_descubierto: bool = false
var catering_descubierto: bool = false

var restaurante_descubierto: bool = false
var cadena_restaurantes_descubierta: bool = false
var grupo_gastronomico_descubierto: bool = false

var distribuidora_descubierta: bool = false
var cadena_descubierta: bool = false
var corporacion_descubierta: bool = false
var multinacional_descubierta: bool = false


# =========================================================
# REFERENCIAS DE INTERFAZ
# =========================================================

@onready var dinero_label: Label = $BarraSuperior/InfoSuperior/DineroLabel
@onready var ronda_label: Label = $BarraSuperior/InfoSuperior/RondaLabel

@onready var negocios_label: Label = $ZonaNegocios/NegociosLabel
@onready var evento_label: Label = $ZonaNegocios/EventoLabel

@onready var cafe_button: Button = $ManoCartas/ContenedorCartas/CafeButton
@onready var comida_button: Button = $ManoCartas/ContenedorCartas/ComidaButton
@onready var vehiculo_button: Button = $ManoCartas/ContenedorCartas/VehiculoButton
@onready var reventa_button: Button = $ManoCartas/ContenedorCartas/ReventaButton

# Mano dinámica v8.3: cada carta de mano se muestra como una tarjeta independiente.
@onready var mano_cartas_panel: Panel = $ManoCartas
@onready var contenedor_cartas_fijas: HBoxContainer = $ManoCartas/ContenedorCartas
var scroll_mano: ScrollContainer
var contenedor_mano_dinamica: HBoxContainer

@onready var fusionar_button: Button = $ZonaNegocios/FusionarButton
@onready var fusion_food_truck_button: Button = $ZonaNegocios/FusionFoodTruckButton
@onready var fusion_catering_button: Button = $ZonaNegocios/FusionCateringButton

@onready var fusion_restaurante_button: Button = $ZonaNegocios/FusionRestauranteButton
@onready var fusion_cadena_restaurantes_button: Button = $ZonaNegocios/FusionCadenaRestaurantesButton

@onready var vender_reventa_button: Button = $ZonaNegocios/VenderReventaButton

@onready var fusion_distribuidora_button: Button = $ZonaNegocios/FusionDistribuidoraButton
@onready var fusion_cadena_button: Button = $ZonaNegocios/FusionCadenaButton
@onready var fusion_corporacion_button: Button = $ZonaNegocios/FusionCorporacionButton
@onready var fusion_multinacional_button: Button = $ZonaNegocios/FusionMultinacionalButton

@onready var nueva_partida_button: Button = $ZonaNegocios/NuevaPartidaButton
@onready var terminar_ronda_button: Button = $TerminarRondaButton


# =========================================================
# INICIO
# =========================================================

func _ready() -> void:
	avisos_placeholder = get_node_or_null("ManoCartas/PanelAvisos/AvisosPlaceholder") as Label
	randomize()

	print("")
	print("================================")
	print("✅ IMPERIO v8.5 — DEUDA Y QUIEBRA")
	print("🖱️ Clic derecho = abrir opciones")
	print("🖱️ Clic izquierdo = jugar/comprar")
	print("================================")
	print("")

	# Los cuatro botones antiguos se conservan en la escena por compatibilidad,
	# pero la v8.3 dibuja la mano carta por carta en un ScrollContainer.
	contenedor_cartas_fijas.visible = false
	crear_mano_dinamica()

	fusionar_button.pressed.connect(fusionar_cafe_comida)
	fusion_food_truck_button.pressed.connect(fusionar_food_truck)
	fusion_catering_button.pressed.connect(fusionar_catering)

	fusion_restaurante_button.pressed.connect(fusionar_restaurante)
	fusion_cadena_restaurantes_button.pressed.connect(
		fusionar_cadena_restaurantes
	)

	vender_reventa_button.pressed.connect(vender_reventa)

	fusion_distribuidora_button.pressed.connect(
		fusionar_distribuidora
	)

	fusion_cadena_button.pressed.connect(
		fusionar_cadena_comercial
	)

	fusion_corporacion_button.pressed.connect(
		fusionar_corporacion
	)

	fusion_multinacional_button.pressed.connect(
		fusionar_multinacional
	)

	nueva_partida_button.pressed.connect(nueva_partida)
	terminar_ronda_button.pressed.connect(terminar_ronda)

	nueva_partida_button.visible = false

	crear_menu_contextual_cartas()
	crear_mensaje_efecto()
	crear_panel_efectos_activos()
	crear_panel_oportunidad()

	acciones_restantes = ACCIONES_POR_RONDA

	crear_mazo_inicial()
	robar_cartas(CARTAS_MANO_INICIAL)

	preparar_ronda()
	actualizar_interfaz()


# =========================================================
# ACCIONES
# =========================================================

func consumir_accion() -> void:
	acciones_restantes -= 1

	if acciones_restantes < 0:
		acciones_restantes = 0

	print("⚡ ACCIONES RESTANTES: ", acciones_restantes)


func tiene_acciones() -> bool:
	return acciones_restantes > 0


# =========================================================
# MAZO Y MANO
# =========================================================

func crear_mazo_inicial() -> void:

	mazo_cartas.clear()
	mano_cartas.clear()
	pila_descarte.clear()

	energia = 0

	for i in range(8):
		mazo_cartas.append("cafe")

	for i in range(8):
		mazo_cartas.append("comida")

	for i in range(7):
		mazo_cartas.append("vehiculo")

	for i in range(7):
		mazo_cartas.append("reventa")

	mazo_cartas.shuffle()

	print("")
	print("================================")
	print("🃏 MAZO CREADO")
	print("Cartas: ", mazo_cartas.size())
	print("================================")
	print("")


func reciclar_descarte() -> void:

	if not mazo_cartas.is_empty():
		return

	if pila_descarte.is_empty():
		return

	print("🔄 BARAJANDO PILA DE DESCARTE")

	for carta in pila_descarte:
		mazo_cartas.append(carta)

	pila_descarte.clear()
	mazo_cartas.shuffle()


func robar_carta() -> void:

	if mazo_cartas.is_empty():
		reciclar_descarte()

	if mazo_cartas.is_empty():
		print("⚠️ NO QUEDAN CARTAS PARA ROBAR")
		return

	var carta: String = mazo_cartas.pop_back()
	mano_cartas.append(carta)

	print("🃏 CARTA ROBADA: ", carta)


func robar_cartas(cantidad: int) -> void:

	for i in range(cantidad):
		robar_carta()

	print("")
	print("🖐️ MANO ACTUAL: ", mano_cartas)
	print("🃏 MAZO: ", mazo_cartas.size())
	print("🗑️ DESCARTE: ", pila_descarte.size())
	print("⭐ ENERGÍA: ", energia, "/", ENERGIA_MAXIMA)
	print("")


func nombre_carta(tipo: String) -> String:

	match tipo:
		"cafe":
			return "☕ CAFÉ"
		"comida":
			return "🍔 COMIDA"
		"vehiculo":
			return "🚚 VEHÍCULO"
		"reventa":
			return "📦 REVENTA"

	return tipo.to_upper()


func nombre_habilidad(tipo: String) -> String:

	match tipo:
		"cafe":
			return "Hora Pico"
		"comida":
			return "Delivery"
		"vehiculo":
			return "Logística"
		"reventa":
			return "Negociación"

	return "Habilidad"


func descripcion_habilidad(tipo: String) -> String:

	match tipo:
		"cafe":
			return "Hora Pico: toda la ruta gastronómica produce +50% esta ronda."
		"comida":
			return "Delivery: toda la ruta gastronómica produce +25% esta ronda y +25% en la siguiente."
		"vehiculo":
			return "Logística: las fusiones que usan Vehículo no consumen acciones esta ronda."
		"reventa":
			return "Negociación: vende la próxima Reventa sin gastar acción y multiplica x3 su ingreso. También puedes guardar Reventa + Vehículo para crear una Distribuidora."

	return ""


func resumen_beneficio_habilidad(tipo: String) -> String:

	var produccion_gastronomica: int = (
		cafes * INGRESO_CAFE
		+ comidas * INGRESO_COMIDA
		+ cafes_bistro * INGRESO_BISTRO
		+ food_trucks * INGRESO_FOOD_TRUCK
		+ catering_moviles * INGRESO_CATERING
		+ restaurantes * INGRESO_RESTAURANTE
		+ cadenas_restaurantes * INGRESO_CADENA_RESTAURANTES
		+ grupos_gastronomicos * INGRESO_GRUPO_GASTRONOMICO
	)

	match tipo:
		"cafe":
			var ganancia_extra: int = int(round(produccion_gastronomica * 0.5))
			if produccion_gastronomica <= 0:
				return "📊 Producción gastronómica actual: $0/ronda\n⚠️ Construye negocios gastronómicos antes de usar Hora Pico."
			return "📊 Gastronomía actual: $%d/ronda\n💰 Extra estimado esta ronda: +$%d" % [produccion_gastronomica, ganancia_extra]

		"comida":
			var extra_por_ronda: int = int(round(produccion_gastronomica * 0.25))
			if produccion_gastronomica <= 0:
				return "📊 Producción gastronómica actual: $0/ronda\n⚠️ Construye negocios gastronómicos antes de usar Delivery."
			return "📊 Gastronomía actual: $%d/ronda\n💰 Extra estimado: +$%d esta ronda y +$%d la siguiente" % [produccion_gastronomica, extra_por_ronda, extra_por_ronda]

		"vehiculo":
			var opciones: int = contar_fusiones_vehiculo_disponibles()
			if opciones <= 0:
				return "🚚 Vehículos disponibles: %d\n⚠️ No tienes una fusión con Vehículo disponible en este momento." % vehiculos
			return "🚚 Vehículos disponibles: %d\n⚙️ Fusiones disponibles ahora: %d\n💡 Cada una puede ahorrar 1 acción esta ronda." % [vehiculos, opciones]

		"reventa":
			if reventas <= 0:
				return "📦 Reventas listas: 0\n💰 Próxima venta: ingreso x3 y no consume acción.\n🚛 Ruta: Reventa + Vehículo = Distribuidora."
			return "📦 Reventas listas: %d\n💰 Próxima venta: ingreso x3 y no consume acción.\n🚛 Alternativa: Reventa + Vehículo = Distribuidora." % reventas

	return ""


func contar_fusiones_vehiculo_disponibles() -> int:
	var opciones: int = 0

	if vehiculos < 1:
		return 0

	if comidas >= 1:
		opciones += 1 # Food Truck

	if cafes_bistro >= 1:
		opciones += 2 # Catering o Restaurante

	if cadenas_restaurantes >= 2:
		opciones += 1 # Grupo Gastronómico
	elif restaurantes >= 2:
		opciones += 1 # Cadena de Restaurantes

	if reventas >= 1:
		opciones += 1 # Distribuidora

	if corporaciones >= 2:
		opciones += 1 # Multinacional

	return opciones


# =========================================================
# MANO DINÁMICA v8.3
# =========================================================

func crear_mano_dinamica() -> void:
	if is_instance_valid(scroll_mano):
		return

	scroll_mano = ScrollContainer.new()
	scroll_mano.name = "ScrollManoDinamica"
	scroll_mano.anchor_right = 1.0
	scroll_mano.anchor_bottom = 1.0
	# v8.8: cartas a la izquierda; extremo derecho reservado para avisos.
	scroll_mano.offset_left = 10.0
	scroll_mano.offset_top = 8.0
	scroll_mano.offset_right = -270.0
	scroll_mano.offset_bottom = -8.0
	scroll_mano.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll_mano.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	mano_cartas_panel.add_child(scroll_mano)

	contenedor_mano_dinamica = HBoxContainer.new()
	contenedor_mano_dinamica.name = "CartasDinamicas"
	contenedor_mano_dinamica.add_theme_constant_override("separation", 10)
	contenedor_mano_dinamica.alignment = BoxContainer.ALIGNMENT_BEGIN
	scroll_mano.add_child(contenedor_mano_dinamica)

	actualizar_mano_dinamica()


func actualizar_mano_dinamica() -> void:
	if not is_instance_valid(contenedor_mano_dinamica):
		return

	var estado_mano := get_node_or_null("ManoCartas/ManoVaciaLabel") as Label
	if estado_mano != null:
		estado_mano.visible = mano_cartas.is_empty()
		if partida_terminada:
			estado_mano.text = "🏁  PARTIDA FINALIZADA"
		else:
			estado_mano.text = "🎴  SIN CARTAS EN MANO\nTermina la ronda para robar nuevas cartas."

	for hijo in contenedor_mano_dinamica.get_children():
		contenedor_mano_dinamica.remove_child(hijo)
		hijo.queue_free()

	for i in range(mano_cartas.size()):
		var tipo: String = mano_cartas[i]
		var carta := crear_tarjeta_visual(tipo, i)
		contenedor_mano_dinamica.add_child(carta)


func crear_tarjeta_visual(tipo: String, indice: int) -> Button:
	var carta := Button.new()
	carta.name = "Carta_%d_%s" % [indice, tipo]
	# Más compacta: entran 5 cartas cómodamente y el resto usa scroll.
	carta.custom_minimum_size = Vector2(158, 116)
	carta.focus_mode = Control.FOCUS_NONE
	carta.add_theme_font_size_override("font_size", 14)
	carta.text = texto_tarjeta_dinamica(tipo)
	carta.tooltip_text = tooltip_tarjeta_dinamica(tipo)
	carta.disabled = partida_terminada
	carta.alignment = HORIZONTAL_ALIGNMENT_CENTER

	var normal := StyleBoxFlat.new()
	normal.bg_color = color_tarjeta(tipo)
	normal.border_color = Color(1.0, 1.0, 1.0, 0.24)
	normal.set_border_width_all(2)
	normal.set_corner_radius_all(14)
	normal.content_margin_left = 8.0
	normal.content_margin_right = 8.0
	normal.content_margin_top = 7.0
	normal.content_margin_bottom = 7.0
	normal.shadow_color = Color(0.0, 0.0, 0.0, 0.38)
	normal.shadow_size = 5

	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = color_tarjeta_hover(tipo)
	hover.border_color = Color(1.0, 1.0, 1.0, 0.55)
	hover.shadow_size = 8

	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = color_tarjeta_presionada(tipo)
	pressed.shadow_size = 2

	var disabled_style := normal.duplicate() as StyleBoxFlat
	disabled_style.bg_color = Color(0.18, 0.18, 0.20, 0.72)
	disabled_style.border_color = Color(1.0, 1.0, 1.0, 0.08)

	carta.add_theme_stylebox_override("normal", normal)
	carta.add_theme_stylebox_override("hover", hover)
	carta.add_theme_stylebox_override("pressed", pressed)
	carta.add_theme_stylebox_override("disabled", disabled_style)
	carta.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	carta.add_theme_color_override("font_hover_color", Color(1.0, 1.0, 1.0, 1.0))
	carta.add_theme_color_override("font_pressed_color", Color(1.0, 1.0, 1.0, 1.0))
	carta.add_theme_color_override("font_disabled_color", Color(0.72, 0.72, 0.74, 1.0))

	carta.pressed.connect(_on_carta_dinamica_pressed.bind(tipo))
	carta.gui_input.connect(_on_carta_gui_input.bind(tipo))

	return carta


func _on_carta_dinamica_pressed(tipo: String) -> void:
	match tipo:
		"cafe":
			comprar_cafe()
		"comida":
			comprar_comida()
		"vehiculo":
			comprar_vehiculo()
		"reventa":
			comprar_reventa()


func texto_tarjeta_dinamica(tipo: String) -> String:
	# Formato vertical y corto para evitar texto cortado.
	match tipo:
		"cafe":
			return "☕\nCAFÉ\n$%d  •  +$%d/ronda\n⚡ Hora Pico\n⭐ %d energía" % [COSTO_CAFE, INGRESO_CAFE, COSTO_HABILIDAD_CAFE]
		"comida":
			return "🍔\nCOMIDA\n$%d  •  +$%d/ronda\n⚡ Delivery\n⭐ %d energía" % [COSTO_COMIDA, INGRESO_COMIDA, COSTO_HABILIDAD_COMIDA]
		"vehiculo":
			return "🚚\nVEHÍCULO\n$%d  •  FUSIONES\n⚡ Logística\n⭐ %d energía" % [COSTO_VEHICULO, COSTO_HABILIDAD_VEHICULO]
		"reventa":
			return "📦\nREVENTA\n$%d  •  VENDER\n⚡ Negociación\n⭐ %d energía" % [COSTO_REVENTA, COSTO_HABILIDAD_REVENTA]
	return tipo.to_upper()


func tooltip_tarjeta_dinamica(tipo: String) -> String:
	# v8.7.1: tooltip corto para no tapar media zona de cartas.
	# El detalle completo de la habilidad sigue disponible con clic derecho.
	return "Clic izquierdo: jugar/comprar\nClic derecho: habilidad o descartar"


func color_tarjeta(tipo: String) -> Color:
	match tipo:
		"cafe":
			return Color("5a3b2e")
		"comida":
			return Color("8a4d24")
		"vehiculo":
			return Color("31566f")
		"reventa":
			return Color("5b456f")
	return Color("3f4650")


func color_tarjeta_hover(tipo: String) -> Color:
	match tipo:
		"cafe":
			return Color("74503e")
		"comida":
			return Color("a9602e")
		"vehiculo":
			return Color("3f708f")
		"reventa":
			return Color("765a90")
	return Color("555d69")


func color_tarjeta_presionada(tipo: String) -> Color:
	match tipo:
		"cafe":
			return Color("493026")
		"comida":
			return Color("703e1e")
		"vehiculo":
			return Color("27465b")
		"reventa":
			return Color("493859")
	return Color("333941")


func crear_menu_contextual_cartas() -> void:

	popup_carta = PopupPanel.new()
	popup_carta.name = "PopupCarta"
	popup_carta.size = Vector2i(360, 250)
	add_child(popup_carta)

	var margen := MarginContainer.new()
	margen.add_theme_constant_override("margin_left", 14)
	margen.add_theme_constant_override("margin_right", 14)
	margen.add_theme_constant_override("margin_top", 12)
	margen.add_theme_constant_override("margin_bottom", 12)
	popup_carta.add_child(margen)

	var columna := VBoxContainer.new()
	columna.add_theme_constant_override("separation", 7)
	margen.add_child(columna)

	popup_titulo = Label.new()
	popup_titulo.add_theme_font_size_override("font_size", 17)
	columna.add_child(popup_titulo)

	popup_descripcion = Label.new()
	popup_descripcion.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	popup_descripcion.custom_minimum_size = Vector2(326, 70)
	columna.add_child(popup_descripcion)

	popup_estado_energia = Label.new()
	columna.add_child(popup_estado_energia)

	popup_usar_habilidad_button = Button.new()
	popup_usar_habilidad_button.custom_minimum_size = Vector2(326, 34)
	popup_usar_habilidad_button.pressed.connect(_on_popup_usar_habilidad)
	columna.add_child(popup_usar_habilidad_button)

	popup_descartar_button = Button.new()
	popup_descartar_button.custom_minimum_size = Vector2(326, 34)
	popup_descartar_button.pressed.connect(_on_popup_descartar)
	columna.add_child(popup_descartar_button)


func crear_mensaje_efecto() -> void:
	mensaje_efecto_panel = PanelContainer.new()
	mensaje_efecto_panel.name = "MensajeEfectoCarta"
	mensaje_efecto_panel.visible = false
	mensaje_efecto_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mensaje_efecto_panel.z_index = 100
	# v8.8: aviso temporal dentro del cuadrito exclusivo a la derecha.
	mensaje_efecto_panel.anchor_left = 1.0
	mensaje_efecto_panel.anchor_right = 1.0
	mensaje_efecto_panel.anchor_top = 0.0
	mensaje_efecto_panel.anchor_bottom = 1.0
	mensaje_efecto_panel.offset_left = -255.0
	mensaje_efecto_panel.offset_right = -10.0
	mensaje_efecto_panel.offset_top = 10.0
	mensaje_efecto_panel.offset_bottom = -10.0
	mano_cartas_panel.add_child(mensaje_efecto_panel)

	var margen := MarginContainer.new()
	margen.add_theme_constant_override("margin_left", 10)
	margen.add_theme_constant_override("margin_right", 10)
	margen.add_theme_constant_override("margin_top", 8)
	margen.add_theme_constant_override("margin_bottom", 8)
	mensaje_efecto_panel.add_child(margen)

	var columna := VBoxContainer.new()
	columna.add_theme_constant_override("separation", 6)
	margen.add_child(columna)

	mensaje_efecto_titulo = Label.new()
	mensaje_efecto_titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mensaje_efecto_titulo.add_theme_font_size_override("font_size", 13)
	columna.add_child(mensaje_efecto_titulo)

	mensaje_efecto_descripcion = Label.new()
	mensaje_efecto_descripcion.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mensaje_efecto_descripcion.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mensaje_efecto_descripcion.add_theme_font_size_override("font_size", 10)
	columna.add_child(mensaje_efecto_descripcion)


func mostrar_mensaje_efecto(titulo: String, descripcion: String) -> void:
	if mensaje_efecto_panel == null:
		return

	if mensaje_efecto_tween != null and mensaje_efecto_tween.is_valid():
		mensaje_efecto_tween.kill()

	mensaje_efecto_titulo.text = titulo
	mensaje_efecto_descripcion.text = descripcion

	if avisos_placeholder != null:
		avisos_placeholder.visible = false

	mensaje_efecto_panel.modulate = Color(1, 1, 1, 1)
	mensaje_efecto_panel.visible = true

	mensaje_efecto_tween = create_tween()
	mensaje_efecto_tween.tween_interval(4.5)
	mensaje_efecto_tween.tween_property(
		mensaje_efecto_panel,
		"modulate:a",
		0.0,
		0.35
	)
	mensaje_efecto_tween.tween_callback(
		func() -> void:
			mensaje_efecto_panel.visible = false
			mensaje_efecto_panel.modulate = Color(1, 1, 1, 1)
			if avisos_placeholder != null:
				avisos_placeholder.visible = true
	)


# =========================================================
# PANEL PERMANENTE DE EFECTOS ACTIVOS
# =========================================================

func crear_panel_efectos_activos() -> void:
	efectos_activos_panel = PanelContainer.new()
	efectos_activos_panel.name = "PanelEfectosActivos"
	efectos_activos_panel.visible = false
	efectos_activos_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	efectos_activos_panel.z_index = 90

	# v8.7: panel fijo dentro de la franja superior derecha.
	# Así nunca invade los botones de Gastronomía/Corporativo.
	efectos_activos_panel.anchor_left = 1.0
	efectos_activos_panel.anchor_right = 1.0
	efectos_activos_panel.anchor_top = 0.0
	efectos_activos_panel.anchor_bottom = 0.0
	efectos_activos_panel.offset_left = -355.0
	efectos_activos_panel.offset_right = -20.0
	efectos_activos_panel.offset_top = 100.0
	efectos_activos_panel.offset_bottom = 216.0
	add_child(efectos_activos_panel)

	var margen := MarginContainer.new()
	margen.add_theme_constant_override("margin_left", 10)
	margen.add_theme_constant_override("margin_right", 10)
	margen.add_theme_constant_override("margin_top", 5)
	margen.add_theme_constant_override("margin_bottom", 5)
	margen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	efectos_activos_panel.add_child(margen)

	efectos_activos_label = Label.new()
	efectos_activos_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	efectos_activos_label.add_theme_font_size_override("font_size", 10)
	efectos_activos_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	efectos_activos_label.text = ""
	margen.add_child(efectos_activos_label)


func actualizar_panel_efectos_activos() -> void:
	if efectos_activos_panel == null or efectos_activos_label == null:
		return

	var lineas: Array[String] = []

	if hora_pico_activa:
		lineas.append("☕ Hora Pico — Gastro +50%")

	if delivery_activo:
		lineas.append("🍔 Delivery — Gastro +25%")

	if logistica_activa:
		lineas.append("🚚 Logística — Fusión c/vehículo sin acción")

	if negociacion_activa:
		lineas.append("📦 Negociación — Reventa x3 sin acción")

	var bonus_gastro: int = int(round(bonus_gastronomia_hitos() * 100.0))
	if bonus_gastro > 0:
		lineas.append("🏆 Gastronomía — +%d%% perm." % bonus_gastro)

	var bonus_comercio: int = int(round(bonus_comercio_hitos() * 100.0))
	if bonus_comercio > 0:
		lineas.append("🏆 Comercio — +%d%% perm." % bonus_comercio)

	var bonus_acciones: int = bonus_acciones_vehiculo()
	if bonus_acciones > 0:
		lineas.append("🏆 Flota — +%d acciones/ronda" % bonus_acciones)

	if ventas_hito_reventa_restantes > 0:
		lineas.append("🏆 Comerciante — %d ventas ≥ $%d" % [ventas_hito_reventa_restantes, minimo_venta_hito_reventa])

	if lineas.is_empty():
		efectos_activos_panel.visible = false
		efectos_activos_label.text = ""
		return

	# Mantener todos los efectos visibles sin ocultarlos detrás de las rutas.
	var tamano_fuente := 10
	if lineas.size() >= 7:
		tamano_fuente = 9
	elif lineas.size() >= 5:
		tamano_fuente = 10

	efectos_activos_label.add_theme_font_size_override("font_size", tamano_fuente)
	efectos_activos_label.text = "⚡ EFECTOS ACTIVOS\n" + "\n".join(lineas)
	efectos_activos_panel.visible = true


func mostrar_menu_carta(tipo: String) -> void:

	if partida_terminada:
		return

	if not mano_cartas.has(tipo):
		return

	carta_menu_actual = tipo

	var costo: int = costo_habilidad(tipo)
	var estrellas: int = int(ESTRELLAS_CARTAS.get(tipo, 1))

	popup_titulo.text = nombre_carta(tipo) + " — " + nombre_habilidad(tipo)
	popup_descripcion.text = (
		descripcion_habilidad(tipo)
		+ "\n\n"
		+ resumen_beneficio_habilidad(tipo)
	)
	popup_estado_energia.text = "⭐ Energía: %d/%d   |   Habilidad: ⭐%d" % [
		energia,
		ENERGIA_MAXIMA,
		costo
	]

	popup_usar_habilidad_button.text = "⚡ USAR HABILIDAD — ⭐%d" % costo
	popup_descartar_button.text = "🗑️ DESCARTAR CARTA — +⭐%d" % estrellas

	var habilidad_disponible: bool = (
		energia >= costo
		and not habilidad_ya_activa(tipo)
	)

	popup_usar_habilidad_button.disabled = not habilidad_disponible

	if habilidad_ya_activa(tipo):
		popup_estado_energia.text += "\n✅ Habilidad ya activa esta ronda."
	elif energia < costo:
		popup_estado_energia.text += "\n⚠️ Te falta energía para usarla."

	var tamano_popup := Vector2i(360, 250)
	var posicion_mouse := Vector2i(get_viewport().get_mouse_position())
	var viewport_size := Vector2i(get_viewport_rect().size)

	# Mantener el menú completamente dentro de la ventana.
	posicion_mouse.x = clampi(
		posicion_mouse.x,
		12,
		max(12, viewport_size.x - tamano_popup.x - 12)
	)
	posicion_mouse.y = clampi(
		posicion_mouse.y,
		12,
		max(12, viewport_size.y - tamano_popup.y - 12)
	)

	print("🖱️ MENÚ ABIERTO: ", tipo)
	popup_carta.popup(Rect2i(posicion_mouse, tamano_popup))


func _on_popup_usar_habilidad() -> void:

	if carta_menu_actual == "":
		return

	var tipo := carta_menu_actual
	popup_carta.hide()
	usar_habilidad_carta(tipo)
	carta_menu_actual = ""


func _on_popup_descartar() -> void:

	if carta_menu_actual == "":
		return

	var tipo := carta_menu_actual
	popup_carta.hide()
	descartar_carta(tipo)
	carta_menu_actual = ""


func usar_carta(tipo: String) -> bool:

	var indice: int = mano_cartas.find(tipo)

	if indice == -1:
		return false

	mano_cartas.remove_at(indice)
	pila_descarte.append(tipo)

	print("▶️ CARTA JUGADA: ", tipo)

	return true


func descartar_carta(tipo: String) -> void:

	if partida_terminada:
		return

	var indice: int = mano_cartas.find(tipo)

	if indice == -1:
		return

	var estrellas: int = int(ESTRELLAS_CARTAS.get(tipo, 1))

	mano_cartas.remove_at(indice)
	pila_descarte.append(tipo)

	energia += estrellas
	energia = min(energia, ENERGIA_MAXIMA)

	print("")
	print("================================")
	print("🗑️ CARTA DESCARTADA: ", tipo)
	print("⭐ ENERGÍA OBTENIDA: +", estrellas)
	print("⭐ ENERGÍA TOTAL: ", energia, "/", ENERGIA_MAXIMA)
	print("🖐️ MANO: ", mano_cartas)
	print("================================")
	print("")

	actualizar_interfaz()


func costo_habilidad(tipo: String) -> int:

	match tipo:
		"cafe":
			return COSTO_HABILIDAD_CAFE
		"comida":
			return COSTO_HABILIDAD_COMIDA
		"vehiculo":
			return COSTO_HABILIDAD_VEHICULO
		"reventa":
			return COSTO_HABILIDAD_REVENTA

	return 999


func habilidad_ya_activa(tipo: String) -> bool:

	match tipo:
		"cafe":
			return hora_pico_activa
		"comida":
			return delivery_activo
		"vehiculo":
			return logistica_activa
		"reventa":
			return negociacion_activa

	return false


func usar_habilidad_carta(tipo: String) -> void:

	if partida_terminada:
		return

	if not mano_cartas.has(tipo):
		return

	if habilidad_ya_activa(tipo):
		print("⚠️ ESA HABILIDAD YA ESTÁ ACTIVA ESTA RONDA")
		return

	var costo: int = costo_habilidad(tipo)

	if energia < costo:
		print("⚠️ ENERGÍA INSUFICIENTE. NECESITAS ⭐", costo)
		return

	var indice: int = mano_cartas.find(tipo)
	mano_cartas.remove_at(indice)
	pila_descarte.append(tipo)
	energia -= costo

	match tipo:
		"cafe":
			hora_pico_activa = true
			mostrar_mensaje_efecto(
				"☕⚡ HORA PICO ACTIVADA",
				"Toda la ruta gastronómica produce +50% esta ronda."
			)
			print("☕⚡ HORA PICO ACTIVADA — GASTRONOMÍA +50%")

		"comida":
			delivery_activo = true
			delivery_rondas_restantes = 2
			mostrar_mensaje_efecto(
				"🍔⚡ DELIVERY ACTIVADO",
				"Toda la ruta gastronómica produce +25% esta ronda y la siguiente."
			)
			print("🍔⚡ DELIVERY ACTIVADO — GASTRONOMÍA +25% POR 2 RONDAS")

		"vehiculo":
			logistica_activa = true
			mostrar_mensaje_efecto(
				"🚚⚡ LOGÍSTICA ACTIVADA",
				"Las fusiones con Vehículo no gastan acciones esta ronda."
			)
			print("🚚⚡ LOGÍSTICA ACTIVADA")
			print("Las fusiones que usan Vehículo no consumen acciones esta ronda.")

		"reventa":
			negociacion_activa = true
			mostrar_mensaje_efecto(
				"📦⚡ NEGOCIACIÓN ACTIVADA",
				"La próxima Reventa será Buena/Extraordinaria, dará x3 y no gastará acción."
			)
			print("📦⚡ NEGOCIACIÓN ACTIVADA — PRÓXIMA VENTA x3 Y SIN ACCIÓN")

	print("⭐ ENERGÍA RESTANTE: ", energia, "/", ENERGIA_MAXIMA)
	print("🖐️ MANO: ", mano_cartas)
	actualizar_interfaz()


func _on_carta_gui_input(
	event: InputEvent,
	tipo: String
) -> void:

	if partida_terminada:
		return

	if event is InputEventMouseButton:

		if (
			event.button_index == MOUSE_BUTTON_RIGHT
			and event.pressed
		):

			print("🖱️ CLIC DERECHO DETECTADO EN: ", tipo)
			mostrar_menu_carta(tipo)
			get_viewport().set_input_as_handled()


# =========================================================
# HITOS EMPRESARIALES v8.1
# =========================================================

func registrar_progreso_hito(tipo: String) -> void:
	match tipo:
		"cafe":
			cafes_comprados_total += 1
		"comida":
			comidas_compradas_total += 1
		"vehiculo":
			vehiculos_comprados_total += 1
		"reventa":
			reventas_compradas_total += 1

	revisar_hitos_empresariales()


func nivel_por_total(total: int) -> int:
	if total >= META_HITO_3:
		return 3
	if total >= META_HITO_2:
		return 2
	if total >= META_HITO_1:
		return 1
	return 0


func bonus_gastronomia_hitos() -> float:
	# Café y Comida se complementan. Si ambos llegan a nivel 3,
	# la ruta gastronómica puede alcanzar +100% permanente.
	var bonus: float = 0.0

	match hito_cafe_nivel:
		1: bonus += 0.10
		2: bonus += 0.25
		3: bonus += 0.50

	match hito_comida_nivel:
		1: bonus += 0.10
		2: bonus += 0.25
		3: bonus += 0.50

	return bonus


func bonus_comercio_hitos() -> float:
	# Reventa desarrolla la especialización comercial/logística.
	match hito_reventa_nivel:
		2:
			return 0.25
		3:
			return 0.50
	return 0.0


func bonus_acciones_vehiculo() -> int:
	# A 6 Vehículos se gana +1 acción permanente por ronda.
	# A 9 Vehículos se gana +2 acciones permanentes por ronda.
	if hito_vehiculo_nivel >= 3:
		return 2
	if hito_vehiculo_nivel >= 2:
		return 1
	return 0


func revisar_hitos_empresariales() -> void:
	var nuevo_nivel_cafe: int = nivel_por_total(cafes_comprados_total)
	var nuevo_nivel_comida: int = nivel_por_total(comidas_compradas_total)
	var nuevo_nivel_vehiculo: int = nivel_por_total(vehiculos_comprados_total)
	var nuevo_nivel_reventa: int = nivel_por_total(reventas_compradas_total)

	if nuevo_nivel_cafe > hito_cafe_nivel:
		hito_cafe_nivel = nuevo_nivel_cafe
		var bonus_actual: int = int(round(bonus_gastronomia_hitos() * 100.0))
		mostrar_mensaje_efecto(
			"🏆 CAFÉ — HITO %d/3" % hito_cafe_nivel,
			"Llegaste a %d Cafés comprados. Bono gastronómico permanente total: +%d%%." % [cafes_comprados_total, bonus_actual]
		)
		print("🏆 HITO CAFÉ NIVEL ", hito_cafe_nivel, " — GASTRONOMÍA +", bonus_actual, "%")

	if nuevo_nivel_comida > hito_comida_nivel:
		hito_comida_nivel = nuevo_nivel_comida
		var bonus_actual: int = int(round(bonus_gastronomia_hitos() * 100.0))
		mostrar_mensaje_efecto(
			"🏆 COMIDA — HITO %d/3" % hito_comida_nivel,
			"Llegaste a %d Comidas compradas. Bono gastronómico permanente total: +%d%%." % [comidas_compradas_total, bonus_actual]
		)
		print("🏆 HITO COMIDA NIVEL ", hito_comida_nivel, " — GASTRONOMÍA +", bonus_actual, "%")

	if nuevo_nivel_vehiculo > hito_vehiculo_nivel:
		var nivel_anterior: int = hito_vehiculo_nivel
		hito_vehiculo_nivel = nuevo_nivel_vehiculo

		if hito_vehiculo_nivel == 1:
			acciones_restantes += 1
			mostrar_mensaje_efecto(
				"🏆 FLOTA EMPRESARIAL 3/9",
				"Obtienes +1 acción inmediatamente. A 6 y 9 Vehículos desbloqueas acciones permanentes."
			)
		elif hito_vehiculo_nivel >= 2:
			# Si se alcanza un nuevo nivel permanente durante la ronda,
			# también se entrega ahora la acción recién desbloqueada.
			var bonus_antes: int = 0
			if nivel_anterior >= 3:
				bonus_antes = 2
			elif nivel_anterior >= 2:
				bonus_antes = 1
			var bonus_ahora: int = bonus_acciones_vehiculo()
			acciones_restantes += max(0, bonus_ahora - bonus_antes)
			mostrar_mensaje_efecto(
				"🏆 FLOTA EMPRESARIAL %d/9" % vehiculos_comprados_total,
				"Ahora comienzas cada ronda con %d acciones." % [ACCIONES_POR_RONDA + bonus_ahora]
			)

		print("🏆 HITO VEHÍCULO NIVEL ", hito_vehiculo_nivel, " — ACCIONES BASE: ", ACCIONES_POR_RONDA + bonus_acciones_vehiculo())

	if nuevo_nivel_reventa > hito_reventa_nivel:
		hito_reventa_nivel = nuevo_nivel_reventa

		if hito_reventa_nivel == 1:
			ventas_hito_reventa_restantes = 2
			minimo_venta_hito_reventa = 50
			mostrar_mensaje_efecto(
				"🏆 COMERCIANTE — 3 REVENTAS",
				"Tus próximas 2 ventas tendrán un ingreso mínimo de $50."
			)
			print("🏆 HITO REVENTA NIVEL 1 — 2 VENTAS CON MÍNIMO $50")
		elif hito_reventa_nivel == 2:
			ventas_hito_reventa_restantes = 2
			minimo_venta_hito_reventa = 90
			mostrar_mensaje_efecto(
				"🏆 COMERCIANTE — 6 REVENTAS",
				"Tus próximas 2 ventas tendrán mínimo $90 y Comercio/Logística obtiene +25% permanente."
			)
			print("🏆 HITO REVENTA NIVEL 2 — COMERCIO +25%")
		elif hito_reventa_nivel == 3:
			ventas_hito_reventa_restantes = 3
			minimo_venta_hito_reventa = 150
			mostrar_mensaje_efecto(
				"🏆 COMERCIANTE — 9 REVENTAS",
				"Tus próximas 3 ventas tendrán mínimo $150 y Comercio/Logística obtiene +50% permanente."
			)
			print("🏆 HITO REVENTA NIVEL 3 — COMERCIO +50%")


func progreso_hito_texto(total: int, nivel: int) -> String:
	if nivel >= 3:
		return "9/9✓"
	if nivel == 2:
		return "%d/9" % min(total, 9)
	if nivel == 1:
		return "%d/6" % min(total, 6)
	return "%d/3" % min(total, 3)


func texto_hitos_compacto() -> String:
	return "🏆 ☕%s  🍔%s  🚚%s  📦%s" % [
		progreso_hito_texto(cafes_comprados_total, hito_cafe_nivel),
		progreso_hito_texto(comidas_compradas_total, hito_comida_nivel),
		progreso_hito_texto(vehiculos_comprados_total, hito_vehiculo_nivel),
		progreso_hito_texto(reventas_compradas_total, hito_reventa_nivel)
	]


# =========================================================
# OPORTUNIDADES EMPRESARIALES v8.4.1
# =========================================================

func crear_panel_oportunidad() -> void:
	oportunidad_panel = PanelContainer.new()
	oportunidad_panel.name = "OportunidadEmpresarial"
	oportunidad_panel.visible = false
	oportunidad_panel.z_index = 200
	oportunidad_panel.anchor_left = 0.5
	oportunidad_panel.anchor_right = 0.5
	oportunidad_panel.anchor_top = 0.5
	oportunidad_panel.anchor_bottom = 0.5
	oportunidad_panel.offset_left = -320.0
	oportunidad_panel.offset_right = 320.0
	oportunidad_panel.offset_top = -190.0
	oportunidad_panel.offset_bottom = 190.0
	add_child(oportunidad_panel)

	var fondo := StyleBoxFlat.new()
	fondo.bg_color = Color("202630")
	fondo.border_color = Color("d6aa58")
	fondo.set_border_width_all(3)
	fondo.set_corner_radius_all(18)
	fondo.shadow_color = Color(0, 0, 0, 0.55)
	fondo.shadow_size = 16
	oportunidad_panel.add_theme_stylebox_override("panel", fondo)

	var margen := MarginContainer.new()
	margen.add_theme_constant_override("margin_left", 28)
	margen.add_theme_constant_override("margin_right", 28)
	margen.add_theme_constant_override("margin_top", 24)
	margen.add_theme_constant_override("margin_bottom", 24)
	oportunidad_panel.add_child(margen)

	var columna := VBoxContainer.new()
	columna.add_theme_constant_override("separation", 14)
	margen.add_child(columna)

	var encabezado := Label.new()
	encabezado.text = "🎴 DECISIÓN EMPRESARIAL"
	encabezado.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	encabezado.add_theme_font_size_override("font_size", 16)
	encabezado.add_theme_color_override("font_color", Color("d6aa58"))
	columna.add_child(encabezado)

	oportunidad_titulo = Label.new()
	oportunidad_titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	oportunidad_titulo.add_theme_font_size_override("font_size", 26)
	columna.add_child(oportunidad_titulo)

	oportunidad_descripcion = Label.new()
	oportunidad_descripcion.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	oportunidad_descripcion.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	oportunidad_descripcion.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	oportunidad_descripcion.custom_minimum_size = Vector2(560, 145)
	oportunidad_descripcion.add_theme_font_size_override("font_size", 16)
	columna.add_child(oportunidad_descripcion)

	var botones := HBoxContainer.new()
	botones.alignment = BoxContainer.ALIGNMENT_CENTER
	botones.add_theme_constant_override("separation", 18)
	columna.add_child(botones)

	oportunidad_aceptar_button = Button.new()
	oportunidad_aceptar_button.custom_minimum_size = Vector2(245, 54)
	oportunidad_aceptar_button.pressed.connect(_on_oportunidad_aceptar)
	botones.add_child(oportunidad_aceptar_button)

	oportunidad_rechazar_button = Button.new()
	oportunidad_rechazar_button.custom_minimum_size = Vector2(245, 54)
	oportunidad_rechazar_button.pressed.connect(_on_oportunidad_rechazar)
	botones.add_child(oportunidad_rechazar_button)


func intentar_generar_oportunidad() -> void:
	if partida_terminada or oportunidad_actual != "":
		return
	if ronda < 4:
		return
	if ronda - ultima_ronda_oportunidad < FRECUENCIA_OPORTUNIDADES:
		return

	var candidatas: Array[String] = []
	var tiene_gastronomia := cafes + comidas + cafes_bistro + food_trucks + catering_moviles + restaurantes + cadenas_restaurantes + grupos_gastronomicos > 0
	var tiene_comercio := distribuidoras + cadenas_comerciales + corporaciones + multinacionales > 0

	if tiene_gastronomia and dinero >= COSTO_CAMPANA_AUSTERA and not oportunidades_usadas.has("campana_local"):
		candidatas.append("campana_local")
	if (restaurantes + cadenas_restaurantes + grupos_gastronomicos) > 0 and dinero >= COSTO_ALQUILER_LOCAL_PREMIUM_RONDA and not oportunidades_usadas.has("local_premium"):
		candidatas.append("local_premium")
	if tiene_comercio and dinero >= COSTO_CONTRATO_RIESGOSO and not oportunidades_usadas.has("contrato_internacional"):
		candidatas.append("contrato_internacional")
	if ronda >= 8 and not oportunidades_usadas.has("inversionista"):
		candidatas.append("inversionista")

	if candidatas.is_empty():
		return

	oportunidad_actual = candidatas.pick_random()
	ultima_ronda_oportunidad = ronda
	mostrar_oportunidad_actual()


func mostrar_oportunidad_actual() -> void:
	match oportunidad_actual:
		"campana_local":
			oportunidad_titulo.text = "📣 CAMPAÑA VIRAL"
			oportunidad_descripcion.text = "El mercado está listo para una campaña.\n\nA) INVERSIÓN FUERTE: $%d → Gastronomía +25%% por 3 rondas.\nB) CAMPAÑA AUSTERA: $%d → Gastronomía +10%% por 4 rondas." % [COSTO_CAMPANA_LOCAL, COSTO_CAMPANA_AUSTERA]
			oportunidad_aceptar_button.text = "A) FUERTE  $%d" % COSTO_CAMPANA_LOCAL
			oportunidad_rechazar_button.text = "B) AUSTERA  $%d" % COSTO_CAMPANA_AUSTERA

		"local_premium":
			oportunidad_titulo.text = "🏢 LOCAL PREMIUM"
			oportunidad_descripcion.text = "Apareció un local clave.\n\nA) PAGO FIJO: $%d → Gastronomía +50%% por 3 rondas.\nB) ALQUILER: $%d al final de cada ronda → +25%% por 4 rondas." % [COSTO_LOCAL_PREMIUM, COSTO_ALQUILER_LOCAL_PREMIUM_RONDA]
			oportunidad_aceptar_button.text = "A) PAGAR  $%d" % COSTO_LOCAL_PREMIUM
			oportunidad_rechazar_button.text = "B) ALQUILAR  $%d/R" % COSTO_ALQUILER_LOCAL_PREMIUM_RONDA

		"contrato_internacional":
			oportunidad_titulo.text = "🚢 CONTRATO INTERNACIONAL"
			oportunidad_descripcion.text = "Dos compradores compiten por tu capacidad.\n\nA) SEGURO: invierte $%d → cobra $%d en 3 rondas.\nB) RIESGO: invierte $%d → 55%% de cobrar $%d en 3 rondas; si falla, pierdes la inversión." % [COSTO_CONTRATO_INTERNACIONAL, PAGO_CONTRATO_INTERNACIONAL, COSTO_CONTRATO_RIESGOSO, PAGO_CONTRATO_RIESGOSO]
			oportunidad_aceptar_button.text = "A) SEGURO  $%d" % COSTO_CONTRATO_INTERNACIONAL
			oportunidad_rechazar_button.text = "B) ARRIESGAR  $%d" % COSTO_CONTRATO_RIESGOSO

		"inversionista":
			oportunidad_titulo.text = "🤝 CAPITAL PARA EXPANDIR"
			oportunidad_descripcion.text = "Necesitas capital para crecer.\n\nA) SOCIO: +$%d ahora, pero cedes 15%% de ingresos por 5 rondas.\nB) PRÉSTAMO: +$%d ahora y pagas $%d dentro de 4 rondas." % [CAPITAL_INVERSIONISTA, CAPITAL_PRESTAMO, PAGO_PRESTAMO]
			oportunidad_aceptar_button.text = "A) SOCIO  +$%d" % CAPITAL_INVERSIONISTA
			oportunidad_rechazar_button.text = "B) PRÉSTAMO  +$%d" % CAPITAL_PRESTAMO

	oportunidad_panel.visible = true


func _on_oportunidad_aceptar() -> void:
	if oportunidad_actual == "":
		return

	match oportunidad_actual:
		"campana_local":
			if dinero < COSTO_CAMPANA_LOCAL:
				mostrar_mensaje_efecto("💸 FALTA DINERO", "Necesitas $%d para la campaña fuerte. Puedes elegir la opción austera." % COSTO_CAMPANA_LOCAL)
				return
			dinero -= COSTO_CAMPANA_LOCAL
			campana_local_rondas = 3
			campana_local_multiplicador = 1.25
			mostrar_mensaje_efecto("📣 CAMPAÑA FUERTE", "-$%d. Gastronomía +25%% durante 3 rondas." % COSTO_CAMPANA_LOCAL)

		"local_premium":
			if dinero < COSTO_LOCAL_PREMIUM:
				mostrar_mensaje_efecto("💸 FALTA DINERO", "Necesitas $%d para el pago fijo. Puedes elegir alquiler." % COSTO_LOCAL_PREMIUM)
				return
			dinero -= COSTO_LOCAL_PREMIUM
			local_premium_rondas = 3
			local_premium_multiplicador = 1.50
			local_premium_alquiler_por_ronda = 0
			mostrar_mensaje_efecto("🏢 LOCAL PREMIUM — PAGO FIJO", "-$%d. Gastronomía +50%% durante 3 rondas." % COSTO_LOCAL_PREMIUM)

		"contrato_internacional":
			if dinero < COSTO_CONTRATO_INTERNACIONAL:
				mostrar_mensaje_efecto("💸 FALTA DINERO", "Necesitas $%d para el contrato seguro. Puedes elegir el contrato de riesgo." % COSTO_CONTRATO_INTERNACIONAL)
				return
			dinero -= COSTO_CONTRATO_INTERNACIONAL
			contrato_internacional_rondas = 3
			contrato_internacional_pago = PAGO_CONTRATO_INTERNACIONAL
			contrato_internacional_riesgoso = false
			mostrar_mensaje_efecto("🚢 CONTRATO SEGURO", "-$%d ahora. Cobrarás $%d en 3 rondas." % [COSTO_CONTRATO_INTERNACIONAL, PAGO_CONTRATO_INTERNACIONAL])

		"inversionista":
			dinero += CAPITAL_INVERSIONISTA
			inversionista_rondas = 5
			mostrar_mensaje_efecto("🤝 NUEVO SOCIO", "+$%d ahora; cedes 15%% de ingresos durante 5 rondas." % CAPITAL_INVERSIONISTA)

	registrar_oportunidad_elegida("A")


func _on_oportunidad_rechazar() -> void:
	if oportunidad_actual == "":
		return

	# En v8.4.1 el segundo botón ya no es simplemente 'rechazar': es una alternativa real.
	match oportunidad_actual:
		"campana_local":
			if dinero < COSTO_CAMPANA_AUSTERA:
				mostrar_mensaje_efecto("💸 FALTA DINERO", "Necesitas $%d para la campaña austera." % COSTO_CAMPANA_AUSTERA)
				return
			dinero -= COSTO_CAMPANA_AUSTERA
			campana_local_rondas = 4
			campana_local_multiplicador = 1.10
			mostrar_mensaje_efecto("📣 CAMPAÑA AUSTERA", "-$%d. Gastronomía +10%% durante 4 rondas." % COSTO_CAMPANA_AUSTERA)

		"local_premium":
			if dinero < COSTO_ALQUILER_LOCAL_PREMIUM_RONDA:
				mostrar_mensaje_efecto("💸 FALTA DINERO", "Necesitas al menos $%d para iniciar el alquiler." % COSTO_ALQUILER_LOCAL_PREMIUM_RONDA)
				return
			local_premium_rondas = 4
			local_premium_multiplicador = 1.25
			local_premium_alquiler_por_ronda = COSTO_ALQUILER_LOCAL_PREMIUM_RONDA
			mostrar_mensaje_efecto("🏢 LOCAL PREMIUM — ALQUILER", "Gastronomía +25%% por 4 rondas; pagarás $%d al final de cada ronda." % COSTO_ALQUILER_LOCAL_PREMIUM_RONDA)

		"contrato_internacional":
			if dinero < COSTO_CONTRATO_RIESGOSO:
				mostrar_mensaje_efecto("💸 FALTA DINERO", "Necesitas $%d para asumir el contrato de riesgo." % COSTO_CONTRATO_RIESGOSO)
				return
			dinero -= COSTO_CONTRATO_RIESGOSO
			contrato_internacional_rondas = 3
			contrato_internacional_pago = PAGO_CONTRATO_RIESGOSO
			contrato_internacional_riesgoso = true
			mostrar_mensaje_efecto("🎲 CONTRATO DE RIESGO", "-$%d ahora. En 3 rondas tendrás 55%% de cobrar $%d." % [COSTO_CONTRATO_RIESGOSO, PAGO_CONTRATO_RIESGOSO])

		"inversionista":
			dinero += CAPITAL_PRESTAMO
			prestamo_rondas = 4
			prestamo_pago_pendiente = PAGO_PRESTAMO
			# Guarda la ronda en que se tomó para no descontar una ronda inmediatamente.
			# Así, "dentro de 4 rondas" significa cuatro cierres futuros completos.
			prestamo_ronda_inicio = ronda
			mostrar_mensaje_efecto("🏦 PRÉSTAMO EMPRESARIAL", "+$%d ahora; pagarás $%d dentro de 4 rondas." % [CAPITAL_PRESTAMO, PAGO_PRESTAMO])

	registrar_oportunidad_elegida("B")


func registrar_oportunidad_elegida(opcion: String) -> void:
	var id_oportunidad := oportunidad_actual
	oportunidades_usadas.append(id_oportunidad)
	print("🎴 DECISIÓN EMPRESARIAL: ", id_oportunidad, " — OPCIÓN ", opcion)
	cerrar_oportunidad()
	actualizar_interfaz()


func cerrar_oportunidad() -> void:
	oportunidad_actual = ""
	if is_instance_valid(oportunidad_panel):
		oportunidad_panel.visible = false


func aplicar_modificadores_oportunidad_gastronomia(valor: int) -> int:
	var resultado := valor
	if campana_local_rondas > 0:
		resultado = int(round(resultado * campana_local_multiplicador))
	if local_premium_rondas > 0:
		resultado = int(round(resultado * local_premium_multiplicador))
	return resultado


func procesar_fin_oportunidades() -> void:
	if campana_local_rondas > 0:
		campana_local_rondas -= 1
		if campana_local_rondas == 0:
			campana_local_multiplicador = 1.0

	if local_premium_rondas > 0:
		if local_premium_alquiler_por_ronda > 0:
			dinero -= local_premium_alquiler_por_ronda
			print("🏢 ALQUILER LOCAL PREMIUM: -$", local_premium_alquiler_por_ronda)
		local_premium_rondas -= 1
		if local_premium_rondas == 0:
			local_premium_multiplicador = 1.0
			local_premium_alquiler_por_ronda = 0

	if inversionista_rondas > 0:
		inversionista_rondas -= 1

	# El préstamo empieza a contar desde la ronda SIGUIENTE a su contratación.
	# Ejemplo: tomado en ronda 11 -> cierres 12, 13, 14, 15 -> pago en ronda 15.
	if prestamo_rondas > 0 and ronda > prestamo_ronda_inicio:
		prestamo_rondas -= 1
		if prestamo_rondas == 0 and prestamo_pago_pendiente > 0:
			dinero -= prestamo_pago_pendiente
			print("🏦 PRÉSTAMO PAGADO: -$", prestamo_pago_pendiente)
			mostrar_mensaje_efecto("🏦 VENCIMIENTO DEL PRÉSTAMO", "-$%d pagados." % prestamo_pago_pendiente)
			prestamo_pago_pendiente = 0
			prestamo_ronda_inicio = 0

	if contrato_internacional_rondas > 0:
		contrato_internacional_rondas -= 1
		if contrato_internacional_rondas == 0:
			if contrato_internacional_riesgoso:
				var tirada_contrato := randi_range(1, 100)
				if tirada_contrato <= PROBABILIDAD_CONTRATO_RIESGOSO:
					dinero += contrato_internacional_pago
					print("🎲 CONTRATO DE RIESGO EXITOSO: +$", contrato_internacional_pago)
					mostrar_mensaje_efecto("🚢 CONTRATO EXITOSO", "+$%d recibidos. La apuesta salió bien." % contrato_internacional_pago)
				else:
					print("💥 CONTRATO DE RIESGO FALLIDO: $0")
					mostrar_mensaje_efecto("💥 CONTRATO FALLIDO", "No hubo pago. Perdiste la inversión inicial.")
			else:
				dinero += contrato_internacional_pago
				print("🚢 CONTRATO SEGURO COBRADO: +$", contrato_internacional_pago)
				mostrar_mensaje_efecto("🚢 CONTRATO COMPLETADO", "+$%d recibidos." % contrato_internacional_pago)

			contrato_internacional_pago = 0
			contrato_internacional_riesgoso = false


# =========================================================
# DEUDA Y QUIEBRA v8.5
# =========================================================

func actualizar_riesgo_quiebra() -> bool:
	if dinero < 0:
		rondas_consecutivas_en_negativo += 1

		print(
			"⚠️ DEUDA: DINERO NEGATIVO — RONDA ",
			rondas_consecutivas_en_negativo,
			"/",
			MAX_RONDAS_CON_DINERO_NEGATIVO
		)

		if rondas_consecutivas_en_negativo >= MAX_RONDAS_CON_DINERO_NEGATIVO:
			return true

		return false

	if rondas_consecutivas_en_negativo > 0:
		print("✅ DEUDA SUPERADA: la empresa volvió a saldo no negativo.")

	rondas_consecutivas_en_negativo = 0
	return false


func texto_riesgo_quiebra() -> String:
	if rondas_consecutivas_en_negativo <= 0:
		return ""

	return "⚠️ Insolvencia — %d/%d rondas negativas; recupera saldo antes del cierre" % [
		rondas_consecutivas_en_negativo,
		MAX_RONDAS_CON_DINERO_NEGATIVO
	]


func texto_oportunidades_activas() -> Array[String]:
	var efectos: Array[String] = []
	if campana_local_rondas > 0:
		var bonus_campana := int(round((campana_local_multiplicador - 1.0) * 100.0))
		efectos.append("📣 Campaña — Gastronomía +%d%% (%d rondas)" % [bonus_campana, campana_local_rondas])
	if local_premium_rondas > 0:
		var bonus_local := int(round((local_premium_multiplicador - 1.0) * 100.0))
		if local_premium_alquiler_por_ronda > 0:
			efectos.append("🏢 Local Premium — +%d%%; -$%d/ronda (%d rondas)" % [bonus_local, local_premium_alquiler_por_ronda, local_premium_rondas])
		else:
			efectos.append("🏢 Local Premium — Gastronomía +%d%% (%d rondas)" % [bonus_local, local_premium_rondas])
	if inversionista_rondas > 0:
		efectos.append("🤝 Socio — -15% ingresos (%d rondas)" % inversionista_rondas)
	if prestamo_rondas > 0:
		efectos.append("🏦 Préstamo — pagar $%d en %d rondas" % [prestamo_pago_pendiente, prestamo_rondas])
	if contrato_internacional_rondas > 0:
		if contrato_internacional_riesgoso:
			efectos.append("🎲 Contrato riesgo — 55% de $%d en %d rondas" % [contrato_internacional_pago, contrato_internacional_rondas])
		else:
			efectos.append("🚢 Contrato seguro — cobra $%d en %d rondas" % [contrato_internacional_pago, contrato_internacional_rondas])
	return efectos


# =========================================================
# EVENTOS
# =========================================================

func preparar_ronda() -> void:

	actualizar_estado_ronda_label()

	print("")
	print("================================")
	print("RONDA ", ronda)
	print("🎴 SIN EVENTOS AUTOMÁTICOS")
	print("Los modificadores especiales se activan con cartas.")
	print(
		"⚡ ACCIONES: ",
		acciones_restantes,
		"/",
		ACCIONES_POR_RONDA
	)
	print("⭐ ENERGÍA: ", energia, "/", ENERGIA_MAXIMA)
	if rondas_consecutivas_en_negativo > 0:
		print(
			"⚠️ RIESGO DE QUIEBRA: ",
			rondas_consecutivas_en_negativo,
			"/",
			MAX_RONDAS_CON_DINERO_NEGATIVO,
			" rondas negativas consecutivas"
		)
	print("================================")
	print("")

	intentar_generar_oportunidad()


func texto_efectos_activos() -> String:

	var efectos: Array[String] = []

	if hora_pico_activa:
		efectos.append("☕ Hora Pico — Gastronomía +50%")

	if delivery_activo:
		efectos.append("🍔 Delivery — Gastronomía +25% (2 rondas)")

	if logistica_activa:
		efectos.append("🚚 Logística — Fusiones con Vehículo sin gastar acción")

	if negociacion_activa:
		efectos.append("📦 Negociación — Próxima Reventa x3 y sin acción")

	var alerta_quiebra := texto_riesgo_quiebra()
	if alerta_quiebra != "":
		efectos.append(alerta_quiebra)

	for efecto_oportunidad in texto_oportunidades_activas():
		efectos.append(efecto_oportunidad)

	if efectos.is_empty():
		return "⚡ Efectos activos: ninguno"

	return "⚡ EFECTOS ACTIVOS\n" + "\n".join(efectos)


func actualizar_estado_ronda_label() -> void:

	evento_label.text = (
		"🎴 HABILIDADES POR CARTAS"
		+ "\n"
		+ "⚡ Acciones: %d/%d    ⭐ Energía: %d/%d    🃏 Mano: %d/%d" % [
			acciones_restantes,
			ACCIONES_POR_RONDA + bonus_acciones_vehiculo(),
			energia,
			ENERGIA_MAXIMA,
			mano_cartas.size(),
			MAX_CARTAS_MANO
		]
		+ "\n"
		+ texto_hitos_compacto()
	)


# =========================================================
# COMPRAR CAFÉ
# =========================================================

func comprar_cafe() -> void:

	if partida_terminada:
		return

	if not mano_cartas.has("cafe"):
		return

	if not tiene_acciones():
		return

	if dinero < COSTO_CAFE:
		return

	if not usar_carta("cafe"):
		return

	dinero -= COSTO_CAFE
	cafes += 1

	consumir_accion()
	registrar_progreso_hito("cafe")

	print("☕ CAFÉ COMPRADO")
	print("DINERO: $", dinero)

	actualizar_interfaz()


# =========================================================
# COMPRAR COMIDA
# =========================================================

func comprar_comida() -> void:

	if partida_terminada:
		return

	if not mano_cartas.has("comida"):
		return

	if not tiene_acciones():
		return

	if dinero < COSTO_COMIDA:
		return

	if not usar_carta("comida"):
		return

	dinero -= COSTO_COMIDA
	comidas += 1

	consumir_accion()
	registrar_progreso_hito("comida")

	print("🍔 COMIDA COMPRADA")
	print("DINERO: $", dinero)

	actualizar_interfaz()


# =========================================================
# COMPRAR VEHÍCULO
# =========================================================

func comprar_vehiculo() -> void:

	if partida_terminada:
		return

	if not mano_cartas.has("vehiculo"):
		return

	if not tiene_acciones():
		return

	if dinero < COSTO_VEHICULO:
		return

	if not usar_carta("vehiculo"):
		return

	dinero -= COSTO_VEHICULO
	vehiculos += 1

	consumir_accion()
	registrar_progreso_hito("vehiculo")

	print("🚚 VEHÍCULO COMPRADO")
	print("DINERO: $", dinero)

	actualizar_interfaz()


# =========================================================
# COMPRAR REVENTA
# =========================================================

func comprar_reventa() -> void:

	if partida_terminada:
		return

	if not mano_cartas.has("reventa"):
		return

	if not tiene_acciones():
		return

	if dinero < COSTO_REVENTA:
		return

	if not usar_carta("reventa"):
		return

	dinero -= COSTO_REVENTA
	reventas += 1

	consumir_accion()
	registrar_progreso_hito("reventa")

	print("")
	print("📦 MERCANCÍA PARA REVENTA COMPRADA")
	print("COSTO: $", COSTO_REVENTA)
	print("REVENTAS DISPONIBLES: ", reventas)
	print("DINERO: $", dinero)
	print("")

	actualizar_interfaz()


# =========================================================
# ACCIONES DE FUSIONES CON VEHÍCULO
# =========================================================

func puede_hacer_fusion_con_vehiculo() -> bool:
	return tiene_acciones() or logistica_activa


func consumir_accion_fusion_vehiculo() -> void:

	if logistica_activa:
		print("🚚⚡ LOGÍSTICA: FUSIÓN SIN GASTAR ACCIÓN")
		return

	consumir_accion()


# =========================================================
# CAFÉ + COMIDA = CAFÉ BISTRÓ
# =========================================================

func fusionar_cafe_comida() -> void:

	if partida_terminada:
		return

	if not tiene_acciones():
		return

	if cafes < 1 or comidas < 1:
		return

	cafes -= 1
	comidas -= 1

	cafes_bistro += 1

	consumir_accion()

	if not bistro_descubierto:

		bistro_descubierto = true

		print("")
		print("================================")
		print("✨ NUEVA FUSIÓN DESCUBIERTA")
		print("🥐 CAFÉ BISTRÓ")
		print("+$45 / RONDA")
		print("================================")
		print("")

	actualizar_interfaz()


# =========================================================
# COMIDA + VEHÍCULO = FOOD TRUCK
# =========================================================

func fusionar_food_truck() -> void:

	if partida_terminada:
		return

	if not puede_hacer_fusion_con_vehiculo():
		return

	if comidas < 1 or vehiculos < 1:
		return

	comidas -= 1
	vehiculos -= 1

	food_trucks += 1

	consumir_accion_fusion_vehiculo()

	if not food_truck_descubierto:

		food_truck_descubierto = true

		print("")
		print("================================")
		print("✨ NUEVA FUSIÓN DESCUBIERTA")
		print("🌮 FOOD TRUCK")
		print("+$90 / RONDA")
		print("================================")
		print("")

	actualizar_interfaz()


# =========================================================
# BISTRÓ + VEHÍCULO = CATERING
# =========================================================

func fusionar_catering() -> void:

	if partida_terminada:
		return

	if not puede_hacer_fusion_con_vehiculo():
		return

	if cafes_bistro < 1 or vehiculos < 1:
		return

	cafes_bistro -= 1
	vehiculos -= 1

	catering_moviles += 1

	consumir_accion_fusion_vehiculo()

	if not catering_descubierto:

		catering_descubierto = true

		print("")
		print("================================")
		print("✨ NUEVA FUSIÓN DESCUBIERTA")
		print("🚚 CATERING MÓVIL")
		print("+$180 / RONDA")
		print("================================")
		print("")

	actualizar_interfaz()


# =========================================================
# BISTRÓ + VEHÍCULO = RESTAURANTE
# =========================================================

func fusionar_restaurante() -> void:

	if partida_terminada:
		return

	if not puede_hacer_fusion_con_vehiculo():
		return

	if cafes_bistro < 1 or vehiculos < 1:
		return

	cafes_bistro -= 1
	vehiculos -= 1

	restaurantes += 1

	consumir_accion_fusion_vehiculo()

	if not restaurante_descubierto:

		restaurante_descubierto = true

		print("")
		print("================================")
		print("✨ NUEVA RUTA DESCUBIERTA")
		print("🍽️ RESTAURANTE")
		print("+$600 / RONDA")
		print("================================")
		print("")

	actualizar_interfaz()


# =========================================================
# 2 RESTAURANTES + VEHÍCULO = CADENA DE RESTAURANTES
# =========================================================

func fusionar_cadena_restaurantes() -> void:

	# Cuando ya existen 2 Cadenas, este mismo botón evoluciona la ruta
	# y permite crear el negocio final gastronómico.
	if cadenas_restaurantes >= 2 and vehiculos >= 1:
		fusionar_grupo_gastronomico()
		return

	if partida_terminada:
		return

	if not puede_hacer_fusion_con_vehiculo():
		return

	if restaurantes < 2 or vehiculos < 1:
		return

	restaurantes -= 2
	vehiculos -= 1

	cadenas_restaurantes += 1

	consumir_accion_fusion_vehiculo()

	if not cadena_restaurantes_descubierta:

		cadena_restaurantes_descubierta = true

		print("")
		print("================================")
		print("✨ NUEVA FUSIÓN DESCUBIERTA")
		print("🍴 CADENA DE RESTAURANTES")
		print("+$6000 / RONDA")
		print("================================")
		print("")

	actualizar_interfaz()


# =========================================================
# 2 CADENAS DE RESTAURANTES + VEHÍCULO = GRUPO GASTRONÓMICO
# =========================================================

func fusionar_grupo_gastronomico() -> void:

	if partida_terminada:
		return

	if not puede_hacer_fusion_con_vehiculo():
		return

	if cadenas_restaurantes < 2 or vehiculos < 1:
		return

	cadenas_restaurantes -= 2
	vehiculos -= 1
	grupos_gastronomicos += 1

	consumir_accion_fusion_vehiculo()

	if not grupo_gastronomico_descubierto:
		grupo_gastronomico_descubierto = true
		mostrar_mensaje_efecto(
			"🏨 GRUPO GASTRONÓMICO",
			"Desbloqueaste el negocio final de Gastronomía: +$25,000 por ronda antes de bonificaciones."
		)
		print("")
		print("================================")
		print("✨ NEGOCIO FINAL GASTRONÓMICO DESCUBIERTO")
		print("🏨 GRUPO GASTRONÓMICO")
		print("+$25000 / RONDA")
		print("================================")
		print("")

	actualizar_interfaz()


# =========================================================
# VENDER REVENTA
# =========================================================

func vender_reventa() -> void:

	if partida_terminada:
		return

	if not tiene_acciones():
		return

	if reventas < 1:
		return

	reventas -= 1

	var venta_con_negociacion: bool = negociacion_activa
	var ingreso: int = resolver_reventa()

	dinero += ingreso

	if venta_con_negociacion:
		print("📦⚡ NEGOCIACIÓN: LA VENTA NO CONSUMIÓ ACCIÓN")
	else:
		consumir_accion()

	print("")
	print("📦 REVENTA VENDIDA")
	print("INGRESO: $", ingreso)
	print("DINERO TOTAL: $", dinero)
	print("REVENTAS RESTANTES: ", reventas)
	print("")

	actualizar_interfaz()


# =========================================================
# REVENTA + VEHÍCULO = DISTRIBUIDORA
# =========================================================

func fusionar_distribuidora() -> void:

	if partida_terminada:
		return

	if not puede_hacer_fusion_con_vehiculo():
		return

	if reventas < 1 or vehiculos < 1:
		return

	reventas -= 1
	vehiculos -= 1

	distribuidoras += 1

	consumir_accion_fusion_vehiculo()

	if not distribuidora_descubierta:

		distribuidora_descubierta = true

		print("")
		print("================================")
		print("✨ NUEVA FUSIÓN DESCUBIERTA")
		print("🚛 DISTRIBUIDORA")
		print("+$200 / RONDA")
		print("================================")
		print("")

	actualizar_interfaz()


# =========================================================
# DISTRIBUIDORA + BISTRÓ = CADENA COMERCIAL
# =========================================================

func fusionar_cadena_comercial() -> void:

	if partida_terminada:
		return

	if not tiene_acciones():
		return

	if distribuidoras < 1 or cafes_bistro < 1:
		return

	distribuidoras -= 1
	cafes_bistro -= 1

	cadenas_comerciales += 1

	consumir_accion()

	if not cadena_descubierta:

		cadena_descubierta = true

		print("")
		print("================================")
		print("✨ NUEVA FUSIÓN DESCUBIERTA")
		print("🏪 CADENA COMERCIAL")
		print("+$900 / RONDA")
		print("================================")
		print("")

	actualizar_interfaz()


# =========================================================
# CADENA COMERCIAL + DISTRIBUIDORA = CORPORACIÓN
# =========================================================

func fusionar_corporacion() -> void:

	if partida_terminada:
		return

	if not tiene_acciones():
		return

	if cadenas_comerciales < 1 or distribuidoras < 1:
		return

	cadenas_comerciales -= 1
	distribuidoras -= 1

	corporaciones += 1

	consumir_accion()

	if not corporacion_descubierta:

		corporacion_descubierta = true

		print("")
		print("================================")
		print("✨ NUEVA FUSIÓN DESCUBIERTA")
		print("🏢 CORPORACIÓN")
		print("+$4000 / RONDA")
		print("================================")
		print("")

	actualizar_interfaz()


# =========================================================
# 2 CORPORACIONES + VEHÍCULO = MULTINACIONAL
# =========================================================

func fusionar_multinacional() -> void:

	if partida_terminada:
		return

	if not puede_hacer_fusion_con_vehiculo():
		return

	if corporaciones < 2 or vehiculos < 1:
		return

	corporaciones -= 2
	vehiculos -= 1

	multinacionales += 1

	consumir_accion_fusion_vehiculo()

	if not multinacional_descubierta:

		multinacional_descubierta = true

		print("")
		print("================================")
		print("✨ NUEVA FUSIÓN DESCUBIERTA")
		print("🌐 MULTINACIONAL")
		print("+$30000 / RONDA")
		print("================================")
		print("")

	actualizar_interfaz()


# =========================================================
# RESULTADO REVENTA
# =========================================================

func resolver_reventa() -> int:
	var ingreso_base: int = 0
	var era_negociacion := negociacion_activa

	if era_negociacion:
		negociacion_activa = false
		var tirada_negociacion: int = randi_range(1, 100)
		if tirada_negociacion <= 75:
			ingreso_base = 90
			print("🟢 NEGOCIACIÓN: BUENA VENTA BASE $90")
		else:
			ingreso_base = 150
			print("💰 NEGOCIACIÓN: VENTA EXTRAORDINARIA BASE $150")
	else:
		var tirada: int = randi_range(1, 100)

		if tirada <= 30:
			ingreso_base = 20
			print("🔴 MALA VENTA: +$20")
		elif tirada <= 70:
			ingreso_base = 50
			print("🟡 VENTA NORMAL: +$50")
		elif tirada <= 92:
			ingreso_base = 90
			print("🟢 BUENA VENTA: +$90")
		else:
			ingreso_base = 150
			print("💰 ¡VENTA EXTRAORDINARIA!: +$150")

	# v8.4.1: TODA venta consume una venta garantizada pendiente,
	# incluida Negociación. El mínimo se aplica al valor base y luego x3.
	if ventas_hito_reventa_restantes > 0:
		ingreso_base = max(ingreso_base, minimo_venta_hito_reventa)
		ventas_hito_reventa_restantes -= 1
		print("🏆 COMERCIANTE: VENTA MÍNIMA GARANTIZADA $", minimo_venta_hito_reventa)
		print("🏆 VENTAS GARANTIZADAS RESTANTES: ", ventas_hito_reventa_restantes)

	if era_negociacion:
		return ingreso_base * 3

	return ingreso_base


# =========================================================
# TERMINAR RONDA
# =========================================================

func terminar_ronda() -> void:

	if partida_terminada:
		return

	if mano_cartas.size() > MAX_CARTAS_MANO:

		print("")
		print("================================")
		print("⚠️ NO PUEDES TERMINAR LA RONDA")
		print("Debes bajar tu mano a ", MAX_CARTAS_MANO, " cartas.")
		print("Cartas actuales: ", mano_cartas.size())
		print("================================")
		print("")

		return

	var ingreso_cafes: int = (
		cafes * INGRESO_CAFE
	)

	var ingreso_comidas: int = (
		comidas * INGRESO_COMIDA
	)

	var ingreso_bistros: int = (
		cafes_bistro * INGRESO_BISTRO
	)

	var ingreso_food_trucks: int = (
		food_trucks * INGRESO_FOOD_TRUCK
	)

	var ingreso_catering: int = (
		catering_moviles * INGRESO_CATERING
	)

	var ingreso_restaurantes: int = (
		restaurantes * INGRESO_RESTAURANTE
	)

	var ingreso_cadenas_restaurantes: int = (
		cadenas_restaurantes
		* INGRESO_CADENA_RESTAURANTES
	)

	var ingreso_grupos_gastronomicos: int = (
		grupos_gastronomicos
		* INGRESO_GRUPO_GASTRONOMICO
	)

	var ingreso_distribuidoras: int = (
		distribuidoras * INGRESO_DISTRIBUIDORA
	)

	var ingreso_cadenas: int = (
		cadenas_comerciales * INGRESO_CADENA
	)

	var ingreso_corporaciones: int = (
		corporaciones * INGRESO_CORPORACION
	)

	var ingreso_multinacionales: int = (
		multinacionales * INGRESO_MULTINACIONAL
	)


	# Habilidades v8: Hora Pico y Delivery afectan TODA la ruta gastronómica.
	if hora_pico_activa:
		ingreso_cafes = int(round(ingreso_cafes * 1.5))
		ingreso_comidas = int(round(ingreso_comidas * 1.5))
		ingreso_bistros = int(round(ingreso_bistros * 1.5))
		ingreso_food_trucks = int(round(ingreso_food_trucks * 1.5))
		ingreso_catering = int(round(ingreso_catering * 1.5))
		ingreso_restaurantes = int(round(ingreso_restaurantes * 1.5))
		ingreso_cadenas_restaurantes = int(round(ingreso_cadenas_restaurantes * 1.5))
		ingreso_grupos_gastronomicos = int(round(ingreso_grupos_gastronomicos * 1.5))

	if delivery_activo:
		ingreso_cafes = int(round(ingreso_cafes * 1.25))
		ingreso_comidas = int(round(ingreso_comidas * 1.25))
		ingreso_bistros = int(round(ingreso_bistros * 1.25))
		ingreso_food_trucks = int(round(ingreso_food_trucks * 1.25))
		ingreso_catering = int(round(ingreso_catering * 1.25))
		ingreso_restaurantes = int(round(ingreso_restaurantes * 1.25))
		ingreso_cadenas_restaurantes = int(round(ingreso_cadenas_restaurantes * 1.25))
		ingreso_grupos_gastronomicos = int(round(ingreso_grupos_gastronomicos * 1.25))

	# Hitos 3/6/9 permanentes.
	var multiplicador_gastro_hitos: float = 1.0 + bonus_gastronomia_hitos()
	if multiplicador_gastro_hitos > 1.0:
		ingreso_cafes = int(round(ingreso_cafes * multiplicador_gastro_hitos))
		ingreso_comidas = int(round(ingreso_comidas * multiplicador_gastro_hitos))
		ingreso_bistros = int(round(ingreso_bistros * multiplicador_gastro_hitos))
		ingreso_food_trucks = int(round(ingreso_food_trucks * multiplicador_gastro_hitos))
		ingreso_catering = int(round(ingreso_catering * multiplicador_gastro_hitos))
		ingreso_restaurantes = int(round(ingreso_restaurantes * multiplicador_gastro_hitos))
		ingreso_cadenas_restaurantes = int(round(ingreso_cadenas_restaurantes * multiplicador_gastro_hitos))
		ingreso_grupos_gastronomicos = int(round(ingreso_grupos_gastronomicos * multiplicador_gastro_hitos))

	# Oportunidades temporales v8.4 también afectan toda la ruta gastronómica.
	ingreso_cafes = aplicar_modificadores_oportunidad_gastronomia(ingreso_cafes)
	ingreso_comidas = aplicar_modificadores_oportunidad_gastronomia(ingreso_comidas)
	ingreso_bistros = aplicar_modificadores_oportunidad_gastronomia(ingreso_bistros)
	ingreso_food_trucks = aplicar_modificadores_oportunidad_gastronomia(ingreso_food_trucks)
	ingreso_catering = aplicar_modificadores_oportunidad_gastronomia(ingreso_catering)
	ingreso_restaurantes = aplicar_modificadores_oportunidad_gastronomia(ingreso_restaurantes)
	ingreso_cadenas_restaurantes = aplicar_modificadores_oportunidad_gastronomia(ingreso_cadenas_restaurantes)
	ingreso_grupos_gastronomicos = aplicar_modificadores_oportunidad_gastronomia(ingreso_grupos_gastronomicos)

	var multiplicador_comercio_hitos: float = 1.0 + bonus_comercio_hitos()
	if multiplicador_comercio_hitos > 1.0:
		ingreso_distribuidoras = int(round(ingreso_distribuidoras * multiplicador_comercio_hitos))
		ingreso_cadenas = int(round(ingreso_cadenas * multiplicador_comercio_hitos))
		ingreso_corporaciones = int(round(ingreso_corporaciones * multiplicador_comercio_hitos))
		ingreso_multinacionales = int(round(ingreso_multinacionales * multiplicador_comercio_hitos))


	var ingresos_base: int = (
		ingreso_cafes
		+ ingreso_comidas
		+ ingreso_bistros
		+ ingreso_food_trucks
		+ ingreso_catering
		+ ingreso_restaurantes
		+ ingreso_cadenas_restaurantes
		+ ingreso_grupos_gastronomicos
		+ ingreso_distribuidoras
		+ ingreso_cadenas
		+ ingreso_corporaciones
		+ ingreso_multinacionales
	)


	# Ya no existen Boom/Recesión automáticos.
	# El ingreso final solo cambia por habilidades activadas mediante cartas.
	var ingresos_totales: int = ingresos_base

	if inversionista_rondas > 0:
		ingresos_totales = int(round(ingresos_totales * 0.85))
		print("🤝 INVERSIONISTA: -15% DE INGRESOS ESTA RONDA")

	dinero += ingresos_totales

	# Avanza contratos y efectos después de cobrar la producción de la ronda.
	procesar_fin_oportunidades()


	# v8.5: tres cierres consecutivos con dinero negativo provocan quiebra.
	var quiebra_por_deuda: bool = actualizar_riesgo_quiebra()


	print("")
	print("================================")
	print("RONDA ", ronda, " TERMINADA")
	print("--------------------------------")

	if hora_pico_activa:
		print("☕⚡ HORA PICO: +50% TODA GASTRONOMÍA")

	if delivery_activo:
		print("🍔⚡ DELIVERY: +25% TODA GASTRONOMÍA")

	if logistica_activa:
		print("🚚⚡ LOGÍSTICA fue utilizada esta ronda")


	print("CAFÉS: $", ingreso_cafes)
	print("COMIDA: $", ingreso_comidas)
	print("BISTRÓS: $", ingreso_bistros)
	print("FOOD TRUCKS: $", ingreso_food_trucks)
	print("CATERING: $", ingreso_catering)

	print(
		"RESTAURANTES: $",
		ingreso_restaurantes
	)

	print(
		"CADENAS DE RESTAURANTES: $",
		ingreso_cadenas_restaurantes
	)

	print(
		"GRUPOS GASTRONÓMICOS: $",
		ingreso_grupos_gastronomicos
	)

	print(
		"DISTRIBUIDORAS: $",
		ingreso_distribuidoras
	)

	print(
		"CADENAS COMERCIALES: $",
		ingreso_cadenas
	)

	print(
		"CORPORACIONES: $",
		ingreso_corporaciones
	)

	print(
		"MULTINACIONALES: $",
		ingreso_multinacionales
	)

	print("--------------------------------")
	print("INGRESO BASE: $", ingresos_base)
	print("MODIFICADORES AUTOMÁTICOS: ninguno")
	print("INGRESOS FINALES: $", ingresos_totales)
	print("DINERO TOTAL: $", dinero)
	print("================================")
	print("")


	if dinero >= OBJETIVO_DINERO:

		ganar_partida()
		return


	if quiebra_por_deuda:

		perder_por_quiebra()
		return


	if ronda >= RONDA_MAXIMA:

		perder_partida()
		return


	# Delivery puede durar dos cierres de ronda.
	if delivery_rondas_restantes > 0:
		delivery_rondas_restantes -= 1

	ronda += 1

	acciones_restantes = ACCIONES_POR_RONDA + bonus_acciones_vehiculo()
	if bonus_acciones_vehiculo() > 0:
		print("🏆 FLOTA EMPRESARIAL: +", bonus_acciones_vehiculo(), " ACCIÓN/ES ESTA RONDA")

	# Hora Pico y Logística duran una sola ronda.
	hora_pico_activa = false
	logistica_activa = false

	# Delivery sigue activo mientras le queden cierres bonificados.
	delivery_activo = delivery_rondas_restantes > 0

	# Negociación se conserva si todavía no se vendió una Reventa.

	robar_cartas(CARTAS_ROBADAS_POR_RONDA)
	preparar_ronda()

	actualizar_interfaz()


# =========================================================
# GANAR
# =========================================================

func ganar_partida() -> void:

	partida_terminada = true

	desactivar_controles()

	dinero_label.text = (
		"💰 $%d" % dinero
	)

	ronda_label.text = (
		"RONDA %d / %d" % [
			ronda,
			RONDA_MAXIMA
		]
	)

	evento_label.text = (
		"🏆 PARTIDA TERMINADA"
	)

	negocios_label.text = (
		"🏆 ¡IMPERIO CREADO!\n\n"
		+ "Patrimonio final: $%d\n"
		+ "Objetivo: $%d\n"
		+ "Rondas utilizadas: %d/%d"
	) % [
		dinero,
		OBJETIVO_DINERO,
		ronda,
		RONDA_MAXIMA
	]

	nueva_partida_button.visible = true


# =========================================================
# QUIEBRA POR DEUDA
# =========================================================

func perder_por_quiebra() -> void:
	partida_terminada = true
	desactivar_controles()

	dinero_label.text = "💰 $%d" % dinero
	ronda_label.text = "RONDA %d / %d" % [ronda, RONDA_MAXIMA]
	evento_label.text = "🏦 QUIEBRA EMPRESARIAL"

	negocios_label.text = (
		"🏦 QUIEBRA EMPRESARIAL\n\n"
		+ "Terminaste %d rondas consecutivas con dinero negativo.\n"
		+ "Patrimonio final: $%d\n"
		+ "Ronda final: %d/%d\n\n"
		+ "Los préstamos pueden acelerar el crecimiento, pero debes recuperar liquidez antes del tercer cierre negativo."
	) % [
		MAX_RONDAS_CON_DINERO_NEGATIVO,
		dinero,
		ronda,
		RONDA_MAXIMA
	]

	nueva_partida_button.visible = true

	print("")
	print("================================")
	print("🏦 QUIEBRA EMPRESARIAL")
	print("Dinero final: $", dinero)
	print("Rondas negativas consecutivas: ", rondas_consecutivas_en_negativo)
	print("================================")
	print("")


# =========================================================
# PERDER
# =========================================================

func perder_partida() -> void:

	partida_terminada = true

	desactivar_controles()

	dinero_label.text = (
		"💰 $%d" % dinero
	)

	ronda_label.text = (
		"RONDA %d / %d" % [
			ronda,
			RONDA_MAXIMA
		]
	)

	evento_label.text = (
		"💀 PARTIDA TERMINADA"
	)

	negocios_label.text = (
		"💀 FIN DE LA PARTIDA\n\n"
		+ "Patrimonio final: $%d\n"
		+ "Objetivo: $%d\n"
		+ "Ronda final: %d/%d\n\n"
		+ "Necesitas construir un imperio más poderoso."
	) % [
		dinero,
		OBJETIVO_DINERO,
		ronda,
		RONDA_MAXIMA
	]

	nueva_partida_button.visible = true


# =========================================================
# NUEVA PARTIDA
# =========================================================

func nueva_partida() -> void:

	dinero = 100
	ronda = 1
	partida_terminada = false
	rondas_consecutivas_en_negativo = 0

	acciones_restantes = ACCIONES_POR_RONDA

	oportunidad_actual = ""
	ultima_ronda_oportunidad = 0
	oportunidades_usadas.clear()
	campana_local_rondas = 0
	campana_local_multiplicador = 1.0
	local_premium_rondas = 0
	local_premium_multiplicador = 1.0
	local_premium_alquiler_por_ronda = 0
	inversionista_rondas = 0
	prestamo_rondas = 0
	prestamo_pago_pendiente = 0
	prestamo_ronda_inicio = 0
	contrato_internacional_rondas = 0
	contrato_internacional_pago = 0
	contrato_internacional_riesgoso = false
	if is_instance_valid(oportunidad_panel):
		oportunidad_panel.visible = false

	hora_pico_activa = false
	delivery_activo = false
	delivery_rondas_restantes = 0
	logistica_activa = false
	negociacion_activa = false

	if efectos_activos_panel != null:
		efectos_activos_panel.visible = false

	cafes = 0
	comidas = 0
	vehiculos = 0
	reventas = 0

	cafes_bistro = 0
	food_trucks = 0
	catering_moviles = 0

	restaurantes = 0
	cadenas_restaurantes = 0
	grupos_gastronomicos = 0

	distribuidoras = 0
	cadenas_comerciales = 0
	corporaciones = 0
	multinacionales = 0

	# Reiniciar progreso y recompensas de hitos 3/6/9.
	cafes_comprados_total = 0
	comidas_compradas_total = 0
	vehiculos_comprados_total = 0
	reventas_compradas_total = 0

	hito_cafe_nivel = 0
	hito_comida_nivel = 0
	hito_vehiculo_nivel = 0
	hito_reventa_nivel = 0

	ventas_hito_reventa_restantes = 0
	minimo_venta_hito_reventa = 0


	bistro_descubierto = false
	food_truck_descubierto = false
	catering_descubierto = false

	restaurante_descubierto = false
	cadena_restaurantes_descubierta = false
	grupo_gastronomico_descubierto = false

	distribuidora_descubierta = false
	cadena_descubierta = false
	corporacion_descubierta = false
	multinacional_descubierta = false



	nueva_partida_button.visible = false

	if is_instance_valid(popup_carta):
		popup_carta.hide()
		carta_menu_actual = ""


	print("")
	print("================================")
	print("🔄 NUEVA PARTIDA")
	print("DINERO: $100")
	print("RONDA 1 / ", RONDA_MAXIMA)
	print("⚡ ACCIONES: ", acciones_restantes)
	print("================================")
	print("")


	crear_mazo_inicial()
	robar_cartas(CARTAS_MANO_INICIAL)

	preparar_ronda()

	actualizar_interfaz()


# =========================================================
# DESACTIVAR CONTROLES
# =========================================================

func desactivar_controles() -> void:

	cafe_button.disabled = true
	comida_button.disabled = true
	vehiculo_button.disabled = true
	reventa_button.disabled = true

	if is_instance_valid(contenedor_mano_dinamica):
		for carta in contenedor_mano_dinamica.get_children():
			if carta is Button:
				carta.disabled = true

	fusionar_button.disabled = true

	fusion_food_truck_button.disabled = true
	fusion_catering_button.disabled = true

	fusion_restaurante_button.disabled = true
	fusion_cadena_restaurantes_button.disabled = true

	vender_reventa_button.disabled = true

	fusion_distribuidora_button.disabled = true
	fusion_cadena_button.disabled = true
	fusion_corporacion_button.disabled = true
	fusion_multinacional_button.disabled = true

	terminar_ronda_button.disabled = true


# =========================================================
# ACTUALIZAR INTERFAZ
# =========================================================

func actualizar_interfaz() -> void:

	dinero_label.text = (
		"💰 $%d" % dinero
	)

	ronda_label.text = (
		"RONDA %d / %d" % [
			ronda,
			RONDA_MAXIMA
		]
	)

	actualizar_estado_ronda_label()
	actualizar_panel_efectos_activos()


	var texto: String = (
		"TUS NEGOCIOS\n\n"
	)


	if (
		cafes == 0
		and comidas == 0
		and vehiculos == 0
		and reventas == 0
		and cafes_bistro == 0
		and food_trucks == 0
		and catering_moviles == 0
		and restaurantes == 0
		and cadenas_restaurantes == 0
		and grupos_gastronomicos == 0
		and distribuidoras == 0
		and cadenas_comerciales == 0
		and corporaciones == 0
		and multinacionales == 0
	):

		texto += (
			"Todavía no tienes negocios."
		)

	else:

		if cafes > 0:

			texto += (
				"☕ Café x%d — $%d / ronda\n"
				% [
					cafes,
					cafes * INGRESO_CAFE
				]
			)


		if comidas > 0:

			texto += (
				"🍔 Comida x%d — $%d / ronda\n"
				% [
					comidas,
					comidas * INGRESO_COMIDA
				]
			)


		if vehiculos > 0:

			texto += (
				"🚚 Vehículo x%d — Infraestructura\n"
				% vehiculos
			)


		if reventas > 0:

			texto += (
				"📦 Reventa x%d — Puedes vender o fusionar\n"
				% reventas
			)


		if cafes_bistro > 0:

			texto += (
				"🥐 Café Bistró x%d — $%d / ronda\n"
				% [
					cafes_bistro,
					cafes_bistro
					* INGRESO_BISTRO
				]
			)


		if food_trucks > 0:

			texto += (
				"🌮 Food Truck x%d — $%d / ronda\n"
				% [
					food_trucks,
					food_trucks
					* INGRESO_FOOD_TRUCK
				]
			)


		if catering_moviles > 0:

			texto += (
				"🚚 Catering Móvil x%d — $%d / ronda\n"
				% [
					catering_moviles,
					catering_moviles
					* INGRESO_CATERING
				]
			)


		if restaurantes > 0:

			texto += (
				"🍽️ Restaurante x%d — $%d / ronda\n"
				% [
					restaurantes,
					restaurantes
					* INGRESO_RESTAURANTE
				]
			)


		if cadenas_restaurantes > 0:

			texto += (
				"🍴 Cadena de Restaurantes x%d — $%d / ronda\n"
				% [
					cadenas_restaurantes,
					cadenas_restaurantes
					* INGRESO_CADENA_RESTAURANTES
				]
			)


		if grupos_gastronomicos > 0:

			texto += (
				"🏨 Grupo Gastronómico x%d — $%d / ronda\n"
				% [
					grupos_gastronomicos,
					grupos_gastronomicos
					* INGRESO_GRUPO_GASTRONOMICO
				]
			)


		if distribuidoras > 0:

			texto += (
				"🚛 Distribuidora x%d — $%d / ronda\n"
				% [
					distribuidoras,
					distribuidoras
					* INGRESO_DISTRIBUIDORA
				]
			)


		if cadenas_comerciales > 0:

			texto += (
				"🏪 Cadena Comercial x%d — $%d / ronda\n"
				% [
					cadenas_comerciales,
					cadenas_comerciales
					* INGRESO_CADENA
				]
			)


		if corporaciones > 0:

			texto += (
				"🏢 Corporación x%d — $%d / ronda\n"
				% [
					corporaciones,
					corporaciones
					* INGRESO_CORPORACION
				]
			)


		if multinacionales > 0:

			texto += (
				"🌐 Multinacional x%d — $%d / ronda\n"
				% [
					multinacionales,
					multinacionales
					* INGRESO_MULTINACIONAL
				]
			)


	negocios_label.text = texto


	var sin_acciones: bool = (
		acciones_restantes <= 0
	)


	var cantidad_cafe: int = mano_cartas.count("cafe")
	var cantidad_comida: int = mano_cartas.count("comida")
	var cantidad_vehiculo: int = mano_cartas.count("vehiculo")
	var cantidad_reventa: int = mano_cartas.count("reventa")

	cafe_button.text = (
		"☕ CAFÉ\n$%d | ⭐\n⚡ Hab: ⭐%d\nx%d" % [
			COSTO_CAFE,
			COSTO_HABILIDAD_CAFE,
			cantidad_cafe
		]
	)

	comida_button.text = (
		"🍔 COMIDA\n$%d | ⭐\n⚡ Hab: ⭐%d\nx%d" % [
			COSTO_COMIDA,
			COSTO_HABILIDAD_COMIDA,
			cantidad_comida
		]
	)

	vehiculo_button.text = (
		"🚚 VEHÍCULO\n$%d | ⭐⭐\n⚡ Hab: ⭐%d\nx%d" % [
			COSTO_VEHICULO,
			COSTO_HABILIDAD_VEHICULO,
			cantidad_vehiculo
		]
	)

	reventa_button.text = (
		"📦 REVENTA\n$%d | VENDER/FUSIONAR\n⚡ Hab: ⭐%d\nx%d" % [
			COSTO_REVENTA,
			COSTO_HABILIDAD_REVENTA,
			cantidad_reventa
		]
	)

	# Redibuja una tarjeta por cada carta real de la mano.
	actualizar_mano_dinamica()


# =========================================================
# COMPRAS
# =========================================================

	cafe_button.disabled = (
		partida_terminada
		or not mano_cartas.has("cafe")
	)


	comida_button.disabled = (
		partida_terminada
		or not mano_cartas.has("comida")
	)


	vehiculo_button.disabled = (
		partida_terminada
		or not mano_cartas.has("vehiculo")
	)


	reventa_button.disabled = (
		partida_terminada
		or not mano_cartas.has("reventa")
	)


# =========================================================
# FUSIONES
# =========================================================

	fusionar_button.disabled = (
		cafes < 1
		or comidas < 1
		or sin_acciones
		or partida_terminada
	)


	fusion_food_truck_button.disabled = (
		comidas < 1
		or vehiculos < 1
		or (sin_acciones and not logistica_activa)
		or partida_terminada
	)


	fusion_catering_button.disabled = (
		cafes_bistro < 1
		or vehiculos < 1
		or (sin_acciones and not logistica_activa)
		or partida_terminada
	)


	fusion_restaurante_button.disabled = (
		cafes_bistro < 1
		or vehiculos < 1
		or (sin_acciones and not logistica_activa)
		or partida_terminada
	)


	var puede_crear_grupo_gastro: bool = (
		cadenas_restaurantes >= 2
		and vehiculos >= 1
	)

	if puede_crear_grupo_gastro:
		fusion_cadena_restaurantes_button.text = "🍴 x2 + 🚚 → 🏨 GRUPO GASTRO"
	else:
		fusion_cadena_restaurantes_button.text = "🍽️ x2 + 🚚 → 🍴 CADENA REST."

	fusion_cadena_restaurantes_button.disabled = (
		(
			not puede_crear_grupo_gastro
			and restaurantes < 2
		)
		or vehiculos < 1
		or (sin_acciones and not logistica_activa)
		or partida_terminada
	)


	vender_reventa_button.disabled = (
		reventas < 1
		or sin_acciones
		or partida_terminada
	)


	fusion_distribuidora_button.disabled = (
		reventas < 1
		or vehiculos < 1
		or (sin_acciones and not logistica_activa)
		or partida_terminada
	)


	fusion_cadena_button.disabled = (
		distribuidoras < 1
		or cafes_bistro < 1
		or sin_acciones
		or partida_terminada
	)


	fusion_corporacion_button.disabled = (
		cadenas_comerciales < 1
		or distribuidoras < 1
		or sin_acciones
		or partida_terminada
	)


	fusion_multinacional_button.disabled = (
		corporaciones < 2
		or vehiculos < 1
		or (sin_acciones and not logistica_activa)
		or partida_terminada
	)


	terminar_ronda_button.disabled = (
		partida_terminada
		or mano_cartas.size() > MAX_CARTAS_MANO
	)
