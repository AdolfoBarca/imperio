extends Control


# =========================================================
# CONFIGURACIÓN GENERAL
# =========================================================

const RONDA_MAXIMA: int = 30
const OBJETIVO_DINERO: int = 1_000_000
const ACCIONES_POR_RONDA: int = 5

const COSTO_CAFE: int = 30
const COSTO_COMIDA: int = 50
const COSTO_VEHICULO: int = 40
const COSTO_REVENTA: int = 25

const INGRESO_CAFE: int = 8
const INGRESO_COMIDA: int = 12
const INGRESO_BISTRO: int = 32
const INGRESO_FOOD_TRUCK: int = 45
const INGRESO_CATERING: int = 85
const INGRESO_RESTAURANTE: int = 100
const INGRESO_CADENA_RESTAURANTES: int = 600
const INGRESO_DISTRIBUIDORA: int = 110
const INGRESO_CADENA: int = 450
const INGRESO_CORPORACION: int = 2500
const INGRESO_MULTINACIONAL: int = 15000



# =========================================================
# ESTADO DE LA PARTIDA
# =========================================================

var dinero: int = 100
var ronda: int = 1
var partida_terminada: bool = false

var acciones_restantes: int = ACCIONES_POR_RONDA


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

var distribuidoras: int = 0
var cadenas_comerciales: int = 0
var corporaciones: int = 0
var multinacionales: int = 0


# =========================================================
# DESCUBRIMIENTOS
# =========================================================

var bistro_descubierto: bool = false
var food_truck_descubierto: bool = false
var catering_descubierto: bool = false

var restaurante_descubierto: bool = false
var cadena_restaurantes_descubierta: bool = false

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
	randomize()

	print("")
	print("================================")
	print("✅ IMPERIO v7 — PREVISUALIZACIÓN DE HABILIDADES")
	print("🖱️ Clic derecho = abrir opciones")
	print("🖱️ Clic izquierdo = jugar/comprar")
	print("================================")
	print("")

	cafe_button.pressed.connect(comprar_cafe)
	comida_button.pressed.connect(comprar_comida)
	vehiculo_button.pressed.connect(comprar_vehiculo)
	reventa_button.pressed.connect(comprar_reventa)

	cafe_button.gui_input.connect(
		_on_carta_gui_input.bind("cafe")
	)

	comida_button.gui_input.connect(
		_on_carta_gui_input.bind("comida")
	)

	vehiculo_button.gui_input.connect(
		_on_carta_gui_input.bind("vehiculo")
	)

	reventa_button.gui_input.connect(
		_on_carta_gui_input.bind("reventa")
	)

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
			return "Cafés y Bistrós producen +50% esta ronda."
		"comida":
			return "Comidas y Restaurantes producen +50% esta ronda."
		"vehiculo":
			return "Las fusiones que usan Vehículo no consumen acciones esta ronda."
		"reventa":
			return "La próxima venta será Buena o Extraordinaria."

	return ""


func resumen_beneficio_habilidad(tipo: String) -> String:

	match tipo:
		"cafe":
			var produccion_afectada: int = (
				cafes * INGRESO_CAFE
				+ cafes_bistro * INGRESO_BISTRO
			)
			var ganancia_extra: int = int(round(produccion_afectada * 0.5))

			if produccion_afectada <= 0:
				return (
					"📊 Producción afectada ahora: $0/ronda\n"
					+ "⚠️ Ahora mismo no tienes Cafés ni Bistrós que aprovechen Hora Pico."
				)

			return (
				"📊 Producción afectada ahora: $%d/ronda\n"
				+ "💰 Ganancia adicional estimada: +$%d esta ronda"
			) % [produccion_afectada, ganancia_extra]

		"comida":
			var produccion_afectada: int = (
				comidas * INGRESO_COMIDA
				+ restaurantes * INGRESO_RESTAURANTE
			)
			var ganancia_extra: int = int(round(produccion_afectada * 0.5))

			if produccion_afectada <= 0:
				return (
					"📊 Producción afectada ahora: $0/ronda\n"
					+ "⚠️ Ahora mismo no tienes Comidas ni Restaurantes que aprovechen Delivery."
				)

			return (
				"📊 Producción afectada ahora: $%d/ronda\n"
				+ "💰 Ganancia adicional estimada: +$%d esta ronda"
			) % [produccion_afectada, ganancia_extra]

		"vehiculo":
			var opciones: int = contar_fusiones_vehiculo_disponibles()

			if opciones <= 0:
				return (
					"🚚 Vehículos disponibles: %d\n"
					+ "⚠️ No tienes una fusión con Vehículo disponible en este momento."
				) % vehiculos

			return (
				"🚚 Vehículos disponibles: %d\n"
				+ "⚙️ Opciones de fusión disponibles ahora: %d\n"
				+ "💡 Cada una puede ahorrarte 1 acción mientras Logística esté activa."
			) % [vehiculos, opciones]

		"reventa":
			if reventas <= 0:
				return (
					"📦 Reventas listas para vender: 0\n"
					+ "💰 Próxima venta con Negociación: $50 o $80\n"
					+ "💡 El efecto se conserva hasta que hagas una venta."
				)

			return (
				"📦 Reventas listas para vender: %d\n"
				+ "💰 Próxima venta garantizada: $50 o $80"
			) % reventas

	return ""


func contar_fusiones_vehiculo_disponibles() -> int:
	var opciones: int = 0

	if vehiculos < 1:
		return 0

	if comidas >= 1:
		opciones += 1 # Food Truck

	if cafes_bistro >= 1:
		opciones += 2 # Catering o Restaurante

	if restaurantes >= 2:
		opciones += 1 # Cadena de Restaurantes

	if reventas >= 1:
		opciones += 1 # Distribuidora

	if corporaciones >= 2:
		opciones += 1 # Multinacional

	return opciones


func crear_menu_contextual_cartas() -> void:

	popup_carta = PopupPanel.new()
	popup_carta.name = "PopupCarta"
	popup_carta.size = Vector2i(420, 330)
	add_child(popup_carta)

	var margen := MarginContainer.new()
	margen.add_theme_constant_override("margin_left", 18)
	margen.add_theme_constant_override("margin_right", 18)
	margen.add_theme_constant_override("margin_top", 16)
	margen.add_theme_constant_override("margin_bottom", 16)
	popup_carta.add_child(margen)

	var columna := VBoxContainer.new()
	columna.add_theme_constant_override("separation", 10)
	margen.add_child(columna)

	popup_titulo = Label.new()
	popup_titulo.add_theme_font_size_override("font_size", 20)
	columna.add_child(popup_titulo)

	popup_descripcion = Label.new()
	popup_descripcion.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	popup_descripcion.custom_minimum_size = Vector2(370, 105)
	columna.add_child(popup_descripcion)

	popup_estado_energia = Label.new()
	columna.add_child(popup_estado_energia)

	popup_usar_habilidad_button = Button.new()
	popup_usar_habilidad_button.custom_minimum_size = Vector2(370, 42)
	popup_usar_habilidad_button.pressed.connect(_on_popup_usar_habilidad)
	columna.add_child(popup_usar_habilidad_button)

	popup_descartar_button = Button.new()
	popup_descartar_button.custom_minimum_size = Vector2(370, 42)
	popup_descartar_button.pressed.connect(_on_popup_descartar)
	columna.add_child(popup_descartar_button)


func crear_mensaje_efecto() -> void:
	mensaje_efecto_panel = PanelContainer.new()
	mensaje_efecto_panel.name = "MensajeEfectoCarta"
	mensaje_efecto_panel.visible = false
	mensaje_efecto_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mensaje_efecto_panel.z_index = 100
	mensaje_efecto_panel.anchor_left = 0.5
	mensaje_efecto_panel.anchor_right = 0.5
	mensaje_efecto_panel.anchor_top = 0.0
	mensaje_efecto_panel.anchor_bottom = 0.0
	mensaje_efecto_panel.offset_left = -260.0
	mensaje_efecto_panel.offset_right = 260.0
	mensaje_efecto_panel.offset_top = 18.0
	mensaje_efecto_panel.offset_bottom = 128.0
	add_child(mensaje_efecto_panel)

	var margen := MarginContainer.new()
	margen.add_theme_constant_override("margin_left", 20)
	margen.add_theme_constant_override("margin_right", 20)
	margen.add_theme_constant_override("margin_top", 14)
	margen.add_theme_constant_override("margin_bottom", 14)
	mensaje_efecto_panel.add_child(margen)

	var columna := VBoxContainer.new()
	columna.add_theme_constant_override("separation", 6)
	margen.add_child(columna)

	mensaje_efecto_titulo = Label.new()
	mensaje_efecto_titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mensaje_efecto_titulo.add_theme_font_size_override("font_size", 22)
	columna.add_child(mensaje_efecto_titulo)

	mensaje_efecto_descripcion = Label.new()
	mensaje_efecto_descripcion.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mensaje_efecto_descripcion.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	mensaje_efecto_descripcion.add_theme_font_size_override("font_size", 16)
	columna.add_child(mensaje_efecto_descripcion)


func mostrar_mensaje_efecto(titulo: String, descripcion: String) -> void:
	if mensaje_efecto_panel == null:
		return

	if mensaje_efecto_tween != null and mensaje_efecto_tween.is_valid():
		mensaje_efecto_tween.kill()

	mensaje_efecto_titulo.text = titulo
	mensaje_efecto_descripcion.text = descripcion
	mensaje_efecto_panel.modulate = Color(1, 1, 1, 1)
	mensaje_efecto_panel.visible = true

	mensaje_efecto_tween = create_tween()
	mensaje_efecto_tween.tween_interval(2.2)
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

	# Esquina superior derecha, debajo de la barra superior.
	efectos_activos_panel.anchor_left = 1.0
	efectos_activos_panel.anchor_right = 1.0
	efectos_activos_panel.anchor_top = 0.0
	efectos_activos_panel.anchor_bottom = 0.0
	efectos_activos_panel.offset_left = -370.0
	efectos_activos_panel.offset_right = -20.0
	efectos_activos_panel.offset_top = 76.0
	efectos_activos_panel.offset_bottom = 230.0
	add_child(efectos_activos_panel)

	var margen := MarginContainer.new()
	margen.add_theme_constant_override("margin_left", 14)
	margen.add_theme_constant_override("margin_right", 14)
	margen.add_theme_constant_override("margin_top", 10)
	margen.add_theme_constant_override("margin_bottom", 10)
	efectos_activos_panel.add_child(margen)

	efectos_activos_label = Label.new()
	efectos_activos_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	efectos_activos_label.add_theme_font_size_override("font_size", 15)
	efectos_activos_label.text = ""
	margen.add_child(efectos_activos_label)


func actualizar_panel_efectos_activos() -> void:
	if efectos_activos_panel == null or efectos_activos_label == null:
		return

	var lineas: Array[String] = []

	if hora_pico_activa:
		lineas.append("☕ Hora Pico — Café/Bistró +50%")

	if delivery_activo:
		lineas.append("🍔 Delivery — Comida/Restaurante +50%")

	if logistica_activa:
		lineas.append("🚚 Logística — Fusiones con Vehículo sin acción")

	if negociacion_activa:
		lineas.append("📦 Negociación — Próxima Reventa mejorada")

	if lineas.is_empty():
		efectos_activos_panel.visible = false
		efectos_activos_label.text = ""
		return

	efectos_activos_label.text = (
		"⚡ EFECTOS ACTIVOS\n"
		+ "\n".join(lineas)
	)
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

	var posicion_mouse := Vector2i(get_viewport().get_mouse_position())
	print("🖱️ MENÚ ABIERTO: ", tipo)
	popup_carta.popup(Rect2i(posicion_mouse, Vector2i(420, 330)))


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
				"Cafés y Bistrós producen +50% esta ronda."
			)
			print("☕⚡ HORA PICO ACTIVADA")
			print("Cafés y Bistrós producen +50% esta ronda.")

		"comida":
			delivery_activo = true
			mostrar_mensaje_efecto(
				"🍔⚡ DELIVERY ACTIVADO",
				"Comidas y Restaurantes producen +50% esta ronda."
			)
			print("🍔⚡ DELIVERY ACTIVADO")
			print("Comidas y Restaurantes producen +50% esta ronda.")

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
				"Tu próxima Reventa será Buena o Extraordinaria."
			)
			print("📦⚡ NEGOCIACIÓN ACTIVADA")
			print("La próxima venta será Buena o Extraordinaria.")

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
	print("================================")
	print("")


func texto_efectos_activos() -> String:

	var efectos: Array[String] = []

	if hora_pico_activa:
		efectos.append("☕ Hora Pico — Café/Bistró +50%")

	if delivery_activo:
		efectos.append("🍔 Delivery — Comida/Restaurante +50%")

	if logistica_activa:
		efectos.append("🚚 Logística — Fusiones con Vehículo sin gastar acción")

	if negociacion_activa:
		efectos.append("📦 Negociación — Próxima Reventa mejorada")

	if efectos.is_empty():
		return "⚡ Efectos activos: ninguno"

	return "⚡ EFECTOS ACTIVOS\n" + "\n".join(efectos)


func actualizar_estado_ronda_label() -> void:

	evento_label.text = (
		"🎴 HABILIDADES POR CARTAS"
		+ "\n"
		+ "⚡ Acciones: %d / %d" % [
			acciones_restantes,
			ACCIONES_POR_RONDA
		]
		+ "\n"
		+ "⭐ Energía: %d / %d" % [
			energia,
			ENERGIA_MAXIMA
		]
		+ "\n"
		+ "🃏 Mano: %d / %d" % [
			mano_cartas.size(),
			MAX_CARTAS_MANO
		]
		+ "\n🖱️ Clic izq.: jugar | Clic der.: opciones"
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
		print("+$32 / RONDA")
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
		print("+$45 / RONDA")
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
		print("+$85 / RONDA")
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
		print("+$100 / RONDA")
		print("================================")
		print("")

	actualizar_interfaz()


# =========================================================
# 2 RESTAURANTES + VEHÍCULO = CADENA DE RESTAURANTES
# =========================================================

func fusionar_cadena_restaurantes() -> void:

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
		print("+$600 / RONDA")
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

	var ingreso: int = resolver_reventa()

	dinero += ingreso

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
		print("+$110 / RONDA")
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
		print("+$450 / RONDA")
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
		print("+$2500 / RONDA")
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
		print("+$15000 / RONDA")
		print("================================")
		print("")

	actualizar_interfaz()


# =========================================================
# RESULTADO REVENTA
# =========================================================

func resolver_reventa() -> int:

	if negociacion_activa:

		negociacion_activa = false

		var tirada_negociacion: int = randi_range(1, 100)

		if tirada_negociacion <= 75:
			print("🟢 NEGOCIACIÓN: BUENA VENTA GARANTIZADA +$50")
			return 50
		else:
			print("💰 NEGOCIACIÓN: ¡VENTA EXTRAORDINARIA! +$80")
			return 80

	var tirada: int = randi_range(1, 100)

	if tirada <= 30:

		print("🔴 MALA VENTA: +$10")
		return 10

	elif tirada <= 70:

		print("🟡 VENTA NORMAL: +$30")
		return 30

	elif tirada <= 92:

		print("🟢 BUENA VENTA: +$50")
		return 50

	else:

		print("💰 ¡VENTA EXTRAORDINARIA!: +$80")
		return 80


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


	if hora_pico_activa:
		ingreso_cafes = int(round(ingreso_cafes * 1.5))
		ingreso_bistros = int(round(ingreso_bistros * 1.5))

	if delivery_activo:
		ingreso_comidas = int(round(ingreso_comidas * 1.5))
		ingreso_restaurantes = int(round(ingreso_restaurantes * 1.5))


	var ingresos_base: int = (
		ingreso_cafes
		+ ingreso_comidas
		+ ingreso_bistros
		+ ingreso_food_trucks
		+ ingreso_catering
		+ ingreso_restaurantes
		+ ingreso_cadenas_restaurantes
		+ ingreso_distribuidoras
		+ ingreso_cadenas
		+ ingreso_corporaciones
		+ ingreso_multinacionales
	)


	# Ya no existen Boom/Recesión automáticos.
	# El ingreso final solo cambia por habilidades activadas mediante cartas.
	var ingresos_totales: int = ingresos_base

	dinero += ingresos_totales


	print("")
	print("================================")
	print("RONDA ", ronda, " TERMINADA")
	print("--------------------------------")

	if hora_pico_activa:
		print("☕⚡ HORA PICO: +50% Café/Bistró")

	if delivery_activo:
		print("🍔⚡ DELIVERY: +50% Comida/Restaurante")

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


	if ronda >= RONDA_MAXIMA:

		perder_partida()
		return


	ronda += 1

	acciones_restantes = ACCIONES_POR_RONDA

	# Las habilidades duran solo una ronda.
	hora_pico_activa = false
	delivery_activo = false
	logistica_activa = false
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

	acciones_restantes = ACCIONES_POR_RONDA

	hora_pico_activa = false
	delivery_activo = false
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

	distribuidoras = 0
	cadenas_comerciales = 0
	corporaciones = 0
	multinacionales = 0


	bistro_descubierto = false
	food_truck_descubierto = false
	catering_descubierto = false

	restaurante_descubierto = false
	cadena_restaurantes_descubierta = false

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
		"📦 REVENTA\n$%d | ⭐\n⚡ Hab: ⭐%d\nx%d" % [
			COSTO_REVENTA,
			COSTO_HABILIDAD_REVENTA,
			cantidad_reventa
		]
	)


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


	fusion_cadena_restaurantes_button.disabled = (
		restaurantes < 2
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
