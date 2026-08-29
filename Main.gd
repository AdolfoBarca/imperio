extends Control


# =========================================================
# CONFIGURACIÓN GENERAL
# =========================================================

const RONDA_MAXIMA: int = 30
const OBJETIVO_DINERO: int = 1_000_000

const COSTO_CAFE: int = 30
const COSTO_COMIDA: int = 50
const COSTO_VEHICULO: int = 40
const COSTO_REVENTA: int = 25

const INGRESO_CAFE: int = 8
const INGRESO_COMIDA: int = 12
const INGRESO_BISTRO: int = 32
const INGRESO_FOOD_TRUCK: int = 45
const INGRESO_CATERING: int = 85
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

@onready var cafe_button: Button = $ManoCartas/ContenedorCartas/CafeButton
@onready var comida_button: Button = $ManoCartas/ContenedorCartas/ComidaButton
@onready var vehiculo_button: Button = $ManoCartas/ContenedorCartas/VehiculoButton
@onready var reventa_button: Button = $ManoCartas/ContenedorCartas/ReventaButton

@onready var fusionar_button: Button = $ZonaNegocios/FusionarButton
@onready var fusion_food_truck_button: Button = $ZonaNegocios/FusionFoodTruckButton
@onready var fusion_catering_button: Button = $ZonaNegocios/FusionCateringButton

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

	cafe_button.pressed.connect(comprar_cafe)
	comida_button.pressed.connect(comprar_comida)
	vehiculo_button.pressed.connect(comprar_vehiculo)
	reventa_button.pressed.connect(comprar_reventa)

	fusionar_button.pressed.connect(fusionar_cafe_comida)
	fusion_food_truck_button.pressed.connect(fusionar_food_truck)
	fusion_catering_button.pressed.connect(fusionar_catering)

	vender_reventa_button.pressed.connect(vender_reventa)
	fusion_distribuidora_button.pressed.connect(fusionar_distribuidora)
	fusion_cadena_button.pressed.connect(fusionar_cadena_comercial)
	fusion_corporacion_button.pressed.connect(fusionar_corporacion)
	fusion_multinacional_button.pressed.connect(fusionar_multinacional)

	nueva_partida_button.pressed.connect(nueva_partida)
	terminar_ronda_button.pressed.connect(terminar_ronda)

	nueva_partida_button.visible = false

	actualizar_interfaz()


# =========================================================
# COMPRAS
# =========================================================

func comprar_cafe() -> void:
	if partida_terminada or dinero < COSTO_CAFE:
		return

	dinero -= COSTO_CAFE
	cafes += 1

	print("☕ CAFÉ COMPRADO")
	print("DINERO: $", dinero)

	actualizar_interfaz()


func comprar_comida() -> void:
	if partida_terminada or dinero < COSTO_COMIDA:
		return

	dinero -= COSTO_COMIDA
	comidas += 1

	print("🍔 COMIDA COMPRADA")
	print("DINERO: $", dinero)

	actualizar_interfaz()


func comprar_vehiculo() -> void:
	if partida_terminada or dinero < COSTO_VEHICULO:
		return

	dinero -= COSTO_VEHICULO
	vehiculos += 1

	print("🚚 VEHÍCULO COMPRADO")
	print("DINERO: $", dinero)

	actualizar_interfaz()


func comprar_reventa() -> void:
	if partida_terminada or dinero < COSTO_REVENTA:
		return

	dinero -= COSTO_REVENTA
	reventas += 1

	print("")
	print("📦 MERCANCÍA PARA REVENTA COMPRADA")
	print("COSTO: $", COSTO_REVENTA)
	print("REVENTAS DISPONIBLES: ", reventas)
	print("DINERO: $", dinero)
	print("")

	actualizar_interfaz()


# =========================================================
# FUSIÓN 1
# CAFÉ + COMIDA = CAFÉ BISTRÓ
# =========================================================

func fusionar_cafe_comida() -> void:
	if partida_terminada:
		return

	if cafes < 1 or comidas < 1:
		return

	cafes -= 1
	comidas -= 1
	cafes_bistro += 1

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
# FUSIÓN 2
# COMIDA + VEHÍCULO = FOOD TRUCK
# =========================================================

func fusionar_food_truck() -> void:
	if partida_terminada:
		return

	if comidas < 1 or vehiculos < 1:
		return

	comidas -= 1
	vehiculos -= 1
	food_trucks += 1

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
# FUSIÓN 3
# CAFÉ BISTRÓ + VEHÍCULO = CATERING MÓVIL
# =========================================================

func fusionar_catering() -> void:
	if partida_terminada:
		return

	if cafes_bistro < 1 or vehiculos < 1:
		return

	cafes_bistro -= 1
	vehiculos -= 1
	catering_moviles += 1

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
# VENDER REVENTA
# =========================================================

func vender_reventa() -> void:
	if partida_terminada:
		return

	if reventas < 1:
		return

	reventas -= 1

	var ingreso: int = resolver_reventa()
	dinero += ingreso

	print("")
	print("📦 REVENTA VENDIDA")
	print("INGRESO: $", ingreso)
	print("DINERO TOTAL: $", dinero)
	print("REVENTAS RESTANTES: ", reventas)
	print("")

	actualizar_interfaz()


# =========================================================
# FUSIÓN 4
# REVENTA + VEHÍCULO = DISTRIBUIDORA
# =========================================================

func fusionar_distribuidora() -> void:
	if partida_terminada:
		return

	if reventas < 1 or vehiculos < 1:
		return

	reventas -= 1
	vehiculos -= 1
	distribuidoras += 1

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
# FUSIÓN 5
# DISTRIBUIDORA + CAFÉ BISTRÓ = CADENA COMERCIAL
# =========================================================

func fusionar_cadena_comercial() -> void:
	if partida_terminada:
		return

	if distribuidoras < 1 or cafes_bistro < 1:
		return

	distribuidoras -= 1
	cafes_bistro -= 1
	cadenas_comerciales += 1

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
# FUSIÓN 6
# CADENA COMERCIAL + DISTRIBUIDORA = CORPORACIÓN
# =========================================================

func fusionar_corporacion() -> void:
	if partida_terminada:
		return

	if cadenas_comerciales < 1 or distribuidoras < 1:
		return

	cadenas_comerciales -= 1
	distribuidoras -= 1
	corporaciones += 1

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
# FUSIÓN 7
# 2 CORPORACIONES + VEHÍCULO = MULTINACIONAL
# =========================================================

func fusionar_multinacional() -> void:
	if partida_terminada:
		return

	if corporaciones < 2 or vehiculos < 1:
		return

	corporaciones -= 2
	vehiculos -= 1
	multinacionales += 1

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
# RESULTADO ALEATORIO DE REVENTA
# =========================================================

func resolver_reventa() -> int:
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

	var ingreso_cafes: int = cafes * INGRESO_CAFE
	var ingreso_comidas: int = comidas * INGRESO_COMIDA
	var ingreso_bistros: int = cafes_bistro * INGRESO_BISTRO
	var ingreso_food_trucks: int = food_trucks * INGRESO_FOOD_TRUCK
	var ingreso_catering: int = catering_moviles * INGRESO_CATERING
	var ingreso_distribuidoras: int = distribuidoras * INGRESO_DISTRIBUIDORA
	var ingreso_cadenas: int = cadenas_comerciales * INGRESO_CADENA
	var ingreso_corporaciones: int = corporaciones * INGRESO_CORPORACION
	var ingreso_multinacionales: int = multinacionales * INGRESO_MULTINACIONAL

	var ingresos_totales: int = (
		ingreso_cafes
		+ ingreso_comidas
		+ ingreso_bistros
		+ ingreso_food_trucks
		+ ingreso_catering
		+ ingreso_distribuidoras
		+ ingreso_cadenas
		+ ingreso_corporaciones
		+ ingreso_multinacionales
	)

	dinero += ingresos_totales

	print("")
	print("================================")
	print("RONDA ", ronda, " TERMINADA")
	print("--------------------------------")
	print("CAFÉS: $", ingreso_cafes)
	print("COMIDA: $", ingreso_comidas)
	print("BISTRÓS: $", ingreso_bistros)
	print("FOOD TRUCKS: $", ingreso_food_trucks)
	print("CATERING: $", ingreso_catering)
	print("DISTRIBUIDORAS: $", ingreso_distribuidoras)
	print("CADENAS COMERCIALES: $", ingreso_cadenas)
	print("CORPORACIONES: $", ingreso_corporaciones)
	print("MULTINACIONALES: $", ingreso_multinacionales)
	print("--------------------------------")
	print("INGRESOS TOTALES: $", ingresos_totales)
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

	actualizar_interfaz()


# =========================================================
# GANAR
# =========================================================

func ganar_partida() -> void:
	partida_terminada = true

	desactivar_controles()

	dinero_label.text = "💰 $%d" % dinero
	ronda_label.text = "RONDA %d / %d" % [ronda, RONDA_MAXIMA]

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

	dinero_label.text = "💰 $%d" % dinero
	ronda_label.text = "RONDA %d / %d" % [ronda, RONDA_MAXIMA]

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

	cafes = 0
	comidas = 0
	vehiculos = 0
	reventas = 0

	cafes_bistro = 0
	food_trucks = 0
	catering_moviles = 0
	distribuidoras = 0
	cadenas_comerciales = 0
	corporaciones = 0
	multinacionales = 0

	bistro_descubierto = false
	food_truck_descubierto = false
	catering_descubierto = false
	distribuidora_descubierta = false
	cadena_descubierta = false
	corporacion_descubierta = false
	multinacional_descubierta = false

	nueva_partida_button.visible = false

	print("")
	print("================================")
	print("🔄 NUEVA PARTIDA")
	print("DINERO: $100")
	print("RONDA 1 / ", RONDA_MAXIMA)
	print("================================")
	print("")

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
	dinero_label.text = "💰 $%d" % dinero

	ronda_label.text = "RONDA %d / %d" % [
		ronda,
		RONDA_MAXIMA
	]

	var texto: String = "TUS NEGOCIOS\n\n"

	if (
		cafes == 0
		and comidas == 0
		and vehiculos == 0
		and reventas == 0
		and cafes_bistro == 0
		and food_trucks == 0
		and catering_moviles == 0
		and distribuidoras == 0
		and cadenas_comerciales == 0
		and corporaciones == 0
		and multinacionales == 0
	):
		texto += "Todavía no tienes negocios."

	else:
		if cafes > 0:
			texto += "☕ Café x%d — $%d / ronda\n" % [
				cafes,
				cafes * INGRESO_CAFE
			]

		if comidas > 0:
			texto += "🍔 Comida x%d — $%d / ronda\n" % [
				comidas,
				comidas * INGRESO_COMIDA
			]

		if vehiculos > 0:
			texto += "🚚 Vehículo x%d — Infraestructura\n" % vehiculos

		if reventas > 0:
			texto += "📦 Reventa x%d — Puedes vender o fusionar\n" % reventas

		if cafes_bistro > 0:
			texto += "🥐 Café Bistró x%d — $%d / ronda\n" % [
				cafes_bistro,
				cafes_bistro * INGRESO_BISTRO
			]

		if food_trucks > 0:
			texto += "🌮 Food Truck x%d — $%d / ronda\n" % [
				food_trucks,
				food_trucks * INGRESO_FOOD_TRUCK
			]

		if catering_moviles > 0:
			texto += "🚚 Catering Móvil x%d — $%d / ronda\n" % [
				catering_moviles,
				catering_moviles * INGRESO_CATERING
			]

		if distribuidoras > 0:
			texto += "🚛 Distribuidora x%d — $%d / ronda\n" % [
				distribuidoras,
				distribuidoras * INGRESO_DISTRIBUIDORA
			]

		if cadenas_comerciales > 0:
			texto += "🏪 Cadena Comercial x%d — $%d / ronda\n" % [
				cadenas_comerciales,
				cadenas_comerciales * INGRESO_CADENA
			]

		if corporaciones > 0:
			texto += "🏢 Corporación x%d — $%d / ronda\n" % [
				corporaciones,
				corporaciones * INGRESO_CORPORACION
			]

		if multinacionales > 0:
			texto += "🌐 Multinacional x%d — $%d / ronda\n" % [
				multinacionales,
				multinacionales * INGRESO_MULTINACIONAL
			]

	negocios_label.text = texto


	# =====================================================
	# COMPRAS
	# =====================================================

	cafe_button.disabled = (
		dinero < COSTO_CAFE
		or partida_terminada
	)

	comida_button.disabled = (
		dinero < COSTO_COMIDA
		or partida_terminada
	)

	vehiculo_button.disabled = (
		dinero < COSTO_VEHICULO
		or partida_terminada
	)

	reventa_button.disabled = (
		dinero < COSTO_REVENTA
		or partida_terminada
	)


	# =====================================================
	# FUSIONES Y REVENTA
	# =====================================================

	fusionar_button.disabled = (
		cafes < 1
		or comidas < 1
		or partida_terminada
	)

	fusion_food_truck_button.disabled = (
		comidas < 1
		or vehiculos < 1
		or partida_terminada
	)

	fusion_catering_button.disabled = (
		cafes_bistro < 1
		or vehiculos < 1
		or partida_terminada
	)

	vender_reventa_button.disabled = (
		reventas < 1
		or partida_terminada
	)

	fusion_distribuidora_button.disabled = (
		reventas < 1
		or vehiculos < 1
		or partida_terminada
	)

	fusion_cadena_button.disabled = (
		distribuidoras < 1
		or cafes_bistro < 1
		or partida_terminada
	)

	fusion_corporacion_button.disabled = (
		cadenas_comerciales < 1
		or distribuidoras < 1
		or partida_terminada
	)

	fusion_multinacional_button.disabled = (
		corporaciones < 2
		or vehiculos < 1
		or partida_terminada
	)


	# =====================================================
	# TERMINAR RONDA
	# =====================================================

	terminar_ronda_button.disabled = partida_terminada