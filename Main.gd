extends Control


var dinero: int = 100
var ronda: int = 1
var cafes: int = 0


@onready var dinero_label: Label = $BarraSuperior/InfoSuperior/DineroLabel
@onready var ronda_label: Label = $BarraSuperior/InfoSuperior/RondaLabel
@onready var negocios_label: Label = $ZonaNegocios/NegociosLabel

@onready var cafe_button: Button = $ManoCartas/ContenedorCartas/CafeButton
@onready var terminar_ronda_button: Button = $TerminarRondaButton


func _ready() -> void:
	cafe_button.pressed.connect(comprar_cafe)
	terminar_ronda_button.pressed.connect(terminar_ronda)

	actualizar_interfaz()


func comprar_cafe() -> void:
	if dinero < 30:
		print("NO TIENES DINERO SUFICIENTE")
		return

	dinero -= 30
	cafes += 1

	print("CAFÉ COMPRADO")
	print("DINERO: $", dinero)
	print("CAFÉS: ", cafes)

	actualizar_interfaz()


func terminar_ronda() -> void:
	var ingresos: int = cafes * 8

	dinero += ingresos
	ronda += 1

	print("RONDA TERMINADA")
	print("INGRESOS: $", ingresos)
	print("DINERO TOTAL: $", dinero)

	actualizar_interfaz()


func actualizar_interfaz() -> void:
	dinero_label.text = "💰 $%d" % dinero
	ronda_label.text = "RONDA %d" % ronda

	if cafes == 0:
		negocios_label.text = "TUS NEGOCIOS\n\nTodavía no tienes negocios."
	else:
		negocios_label.text = "TUS NEGOCIOS\n\n☕ Café x%d\nProduce: $%d / ronda" % [
			cafes,
			cafes * 8
		]