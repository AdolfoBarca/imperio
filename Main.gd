extends Control


# =========================================================
# CONFIGURACIÓN GENERAL
# =========================================================

const RONDA_MAXIMA: int = 30
const OBJETIVO_DINERO: int = 1_000_000

const COSTO_CAFE: int = 30
const COSTO_COMIDA: int = 50
const COSTO_VEHICULO: int = 40

const INGRESO_CAFE: int = 8
const INGRESO_COMIDA: int = 12
const INGRESO_BISTRO: int = 32
const INGRESO_FOOD_TRUCK: int = 45
const INGRESO_CATERING: int = 85


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

var cafes_bistro: int = 0
var food_trucks: int = 0
var catering_moviles: int = 0


# =========================================================
# DESCUBRIMIENTOS
# Estos NO se reinician al iniciar otra partida.
# =========================================================

var bistro_descubierto: bool = false
var food_truck_descubierto: bool = false
var catering_descubierto: bool = false


# =========================================================
# REFERENCIAS DE INTERFAZ
# =========================================================

@onready var dinero_label: Label = $BarraSuperior/InfoSuperior/DineroLabel
@onready var ronda_label: Label = $BarraSuperior/InfoSuperior/RondaLabel
@onready var negocios_label: Label = $ZonaNegocios/NegociosLabel

@onready var cafe_button: Button = $ManoCartas/ContenedorCartas/CafeButton
@onready var comida_button: Button = $ManoCartas/ContenedorCartas/ComidaButton
@onready var vehiculo_button: Button = $ManoCartas/ContenedorCartas/VehiculoButton

@onready var fusionar_button: Button = $ZonaNegocios/FusionarButton
@onready var fusion_food_truck_button: Button = $ZonaNegocios/FusionFoodTruckButton
@onready var fusion_catering_button: Button = $ZonaNegocios/FusionCateringButton

@onready var nueva_partida_button: Button = $ZonaNegocios/NuevaPartidaButton
@onready var terminar_ronda_button: Button = $TerminarRondaButton


# =========================================================
# INICIO
# =========================================================

func _ready() -> void:
	cafe_button.pressed.connect(comprar_cafe)
	comida_button.pressed.connect(comprar_comida)
	vehiculo_button.pressed.connect(comprar_vehiculo)

	fusionar_button.pressed.connect(fusionar_cafe_comida)
	fusion_food_truck_button.pressed.connect(fusionar_food_truck)
	fusion_catering_button.pressed.connect(fusionar_catering)

	nueva_partida_button.pressed.connect(nueva_partida)
	terminar_ronda_button.pressed.connect(terminar_ronda)

	nueva_partida_button.visible = false

	actualizar_interfaz()


# =========================================================
# COMPRAR CAFÉ
# =========================================================

func comprar_cafe() -> void:
	if partida_terminada:
		return

	if dinero < COSTO_CAFE:
		return

	dinero -= COSTO_CAFE
	cafes += 1

	print("☕ CAFÉ COMPRADO")
	print("DINERO: $", dinero)

	actualizar_interfaz()


# =========================================================
# COMPRAR COMIDA
# =========================================================

func comprar_comida() -> void:
	if partida_terminada:
		return

	if dinero < COSTO_COMIDA:
		return

	dinero -= COSTO_COMIDA
	comidas += 1

	print("🍔 COMIDA COMPRADA")
	print("DINERO: $", dinero)

	actualizar_interfaz()


# =========================================================
# COMPRAR VEHÍCULO
# =========================================================

func comprar_vehiculo() -> void:
	if partida_terminada:
		return

	if dinero < COSTO_VEHICULO:
		return

	dinero -= COSTO_VEHICULO
	vehiculos += 1

	print("🚚 VEHÍCULO COMPRADO")
	print("DINERO: $", dinero)

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

	var ingresos_totales: int = (
		ingreso_cafes
		+ ingreso_comidas
		+ ingreso_bistros
		+ ingreso_food_trucks
		+ ingreso_catering
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
	print("--------------------------------")
	print("INGRESOS: $", ingresos_totales)
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

	cafes_bistro = 0
	food_trucks = 0
	catering_moviles = 0

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

	fusionar_button.disabled = true
	fusion_food_truck_button.disabled = true
	fusion_catering_button.disabled = true

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
		and cafes_bistro == 0
		and food_trucks == 0
		and catering_moviles == 0
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


	# =====================================================
	# FUSIONES
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


	# =====================================================
	# TERMINAR RONDA
	# =====================================================

	terminar_ronda_button.disabled = partida_terminada