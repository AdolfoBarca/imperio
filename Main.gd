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

const PROBABILIDAD_EVENTO: int = 35


# =========================================================
# ESTADO DE LA PARTIDA
# =========================================================

var dinero: int = 100
var ronda: int = 1
var partida_terminada: bool = false

var acciones_restantes: int = ACCIONES_POR_RONDA


# =========================================================
# OPORTUNIDADES
# =========================================================

const CANTIDAD_OPORTUNIDADES: int = 3
var oportunidades_ronda: Array[String] = []


# =========================================================
# EVENTO
# =========================================================

var multiplicador_ingresos: float = 1.0
var nombre_evento: String = "⚖️ MERCADO ESTABLE"
var descripcion_evento: String = "Ingresos normales esta ronda."


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

	cafe_button.pressed.connect(comprar_cafe)
	comida_button.pressed.connect(comprar_comida)
	vehiculo_button.pressed.connect(comprar_vehiculo)
	reventa_button.pressed.connect(comprar_reventa)

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

	acciones_restantes = ACCIONES_POR_RONDA

	generar_evento_ronda()
	generar_oportunidades_ronda()
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
# OPORTUNIDADES
# =========================================================

func generar_oportunidades_ronda() -> void:

	var disponibles: Array[String] = [
		"cafe",
		"comida",
		"vehiculo",
		"reventa"
	]

	disponibles.shuffle()

	oportunidades_ronda.clear()

	for i in range(CANTIDAD_OPORTUNIDADES):
		oportunidades_ronda.append(disponibles[i])

	print("")
	print("================================")
	print("🎴 OPORTUNIDADES RONDA ", ronda)
	print(oportunidades_ronda)
	print("================================")
	print("")


# =========================================================
# EVENTOS
# =========================================================

func generar_evento_ronda() -> void:

	var tirada: int = randi_range(1, 100)

	if tirada > PROBABILIDAD_EVENTO:

		multiplicador_ingresos = 1.0

		nombre_evento = "⚖️ MERCADO ESTABLE"

		descripcion_evento = (
			"Ingresos normales esta ronda."
		)

	else:

		var tipo_evento: int = randi_range(1, 2)

		if tipo_evento == 1:

			multiplicador_ingresos = 1.5

			nombre_evento = "📈 BOOM DE CONSUMO"

			descripcion_evento = (
				"Todos tus negocios producen +50% esta ronda."
			)

		else:

			multiplicador_ingresos = 0.75

			nombre_evento = "📉 RECESIÓN"

			descripcion_evento = (
				"Todos tus negocios producen -25% esta ronda."
			)

	actualizar_evento_label()

	print("")
	print("================================")
	print("EVENTO RONDA ", ronda)
	print(nombre_evento)
	print(descripcion_evento)
	print(
		"⚡ ACCIONES: ",
		acciones_restantes,
		"/",
		ACCIONES_POR_RONDA
	)
	print("================================")
	print("")


func actualizar_evento_label() -> void:

	evento_label.text = (
		nombre_evento
		+ "\n"
		+ descripcion_evento
		+ "\n"
		+ "⚡ Acciones: %d / %d" % [
			acciones_restantes,
			ACCIONES_POR_RONDA
		]
	)


# =========================================================
# COMPRAR CAFÉ
# =========================================================

func comprar_cafe() -> void:

	if partida_terminada:
		return

	if not oportunidades_ronda.has("cafe"):
		return

	if not tiene_acciones():
		return

	if dinero < COSTO_CAFE:
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

	if not oportunidades_ronda.has("comida"):
		return

	if not tiene_acciones():
		return

	if dinero < COSTO_COMIDA:
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

	if not oportunidades_ronda.has("vehiculo"):
		return

	if not tiene_acciones():
		return

	if dinero < COSTO_VEHICULO:
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

	if not oportunidades_ronda.has("reventa"):
		return

	if not tiene_acciones():
		return

	if dinero < COSTO_REVENTA:
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

	if not tiene_acciones():
		return

	if comidas < 1 or vehiculos < 1:
		return

	comidas -= 1
	vehiculos -= 1

	food_trucks += 1

	consumir_accion()

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

	if not tiene_acciones():
		return

	if cafes_bistro < 1 or vehiculos < 1:
		return

	cafes_bistro -= 1
	vehiculos -= 1

	catering_moviles += 1

	consumir_accion()

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

	if not tiene_acciones():
		return

	if cafes_bistro < 1 or vehiculos < 1:
		return

	cafes_bistro -= 1
	vehiculos -= 1

	restaurantes += 1

	consumir_accion()

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

	if not tiene_acciones():
		return

	if restaurantes < 2 or vehiculos < 1:
		return

	restaurantes -= 2
	vehiculos -= 1

	cadenas_restaurantes += 1

	consumir_accion()

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

	if not tiene_acciones():
		return

	if reventas < 1 or vehiculos < 1:
		return

	reventas -= 1
	vehiculos -= 1

	distribuidoras += 1

	consumir_accion()

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

	if not tiene_acciones():
		return

	if corporaciones < 2 or vehiculos < 1:
		return

	corporaciones -= 2
	vehiculos -= 1

	multinacionales += 1

	consumir_accion()

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


	var ingresos_totales: int = int(
		round(
			ingresos_base
			* multiplicador_ingresos
		)
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
	print("EVENTO: ", nombre_evento)
	print("MULTIPLICADOR: x", multiplicador_ingresos)
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

	generar_evento_ronda()
	generar_oportunidades_ronda()

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


	multiplicador_ingresos = 1.0

	nombre_evento = (
		"⚖️ MERCADO ESTABLE"
	)

	descripcion_evento = (
		"Ingresos normales esta ronda."
	)

	nueva_partida_button.visible = false


	print("")
	print("================================")
	print("🔄 NUEVA PARTIDA")
	print("DINERO: $100")
	print("RONDA 1 / ", RONDA_MAXIMA)
	print("⚡ ACCIONES: ", acciones_restantes)
	print("================================")
	print("")


	generar_evento_ronda()
	generar_oportunidades_ronda()

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

	actualizar_evento_label()


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


# =========================================================
# COMPRAS
# =========================================================

	cafe_button.disabled = (
		dinero < COSTO_CAFE
		or sin_acciones
		or partida_terminada
		or not oportunidades_ronda.has("cafe")
	)


	comida_button.disabled = (
		dinero < COSTO_COMIDA
		or sin_acciones
		or partida_terminada
		or not oportunidades_ronda.has("comida")
	)


	vehiculo_button.disabled = (
		dinero < COSTO_VEHICULO
		or sin_acciones
		or partida_terminada
		or not oportunidades_ronda.has("vehiculo")
	)


	reventa_button.disabled = (
		dinero < COSTO_REVENTA
		or sin_acciones
		or partida_terminada
		or not oportunidades_ronda.has("reventa")
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
		or sin_acciones
		or partida_terminada
	)


	fusion_catering_button.disabled = (
		cafes_bistro < 1
		or vehiculos < 1
		or sin_acciones
		or partida_terminada
	)


	fusion_restaurante_button.disabled = (
		cafes_bistro < 1
		or vehiculos < 1
		or sin_acciones
		or partida_terminada
	)


	fusion_cadena_restaurantes_button.disabled = (
		restaurantes < 2
		or vehiculos < 1
		or sin_acciones
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
		or sin_acciones
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
		or sin_acciones
		or partida_terminada
	)


	terminar_ronda_button.disabled = (
		partida_terminada
	)
