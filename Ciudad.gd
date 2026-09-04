extends Control


@onready var volver_button: Button = $VolverButton
@onready var mapa_barrio: TextureRect = $MapaBarrio
@onready var cafe_visual: TextureRect = $CafeVisual
@onready var comida_visual: TextureRect = $ComidaVisual
@onready var cafe_bistro_visual: TextureRect = $CafeBistroVisual
@onready var restaurante_visual: TextureRect = $RestauranteVisual


func _ready() -> void:
	print("🏙️ CIUDAD INICIADA")

	# =========================================================
	# CIUDAD A PANTALLA COMPLETA
	# =========================================================

	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


	# =========================================================
	# MAPA
	# =========================================================

	if mapa_barrio != null:
		mapa_barrio.mouse_filter = Control.MOUSE_FILTER_IGNORE
		mapa_barrio.z_index = 0


	# =========================================================
	# EDIFICIOS VISUALES
	# =========================================================

	if cafe_visual != null:
		cafe_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cafe_visual.z_index = 10

	if comida_visual != null:
		comida_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
		comida_visual.z_index = 10

	if cafe_bistro_visual != null:
		cafe_bistro_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cafe_bistro_visual.z_index = 20

	if restaurante_visual != null:
		restaurante_visual.mouse_filter = Control.MOUSE_FILTER_IGNORE
		restaurante_visual.z_index = 30


	# =========================================================
	# BOTÓN VOLVER
	# =========================================================

	volver_button.visible = true
	volver_button.disabled = false
	volver_button.mouse_filter = Control.MOUSE_FILTER_STOP
	volver_button.z_index = 2000
	volver_button.position = Vector2(20, 20)
	volver_button.size = Vector2(150, 48)
	volver_button.text = "⬅ VOLVER"

	if not volver_button.pressed.is_connected(_on_volver_pressed):
		volver_button.pressed.connect(_on_volver_pressed)

	print("✅ BOTÓN VOLVER PREPARADO")


# =========================================================
# RECIBIR DATOS DESDE MAIN
# =========================================================

func configurar(
	cafes_actuales: int,
	comidas_actuales: int,
	cafes_bistro_actuales: int,
	restaurantes_actuales: int
) -> void:

	# =========================================================
	# EVOLUCIÓN VISUAL DE LA PARCELA PRINCIPAL
	# Café -> Café Bistró -> Restaurante
	# =========================================================

	if restaurante_visual != null:
		restaurante_visual.visible = restaurantes_actuales > 0

	if cafe_bistro_visual != null:
		cafe_bistro_visual.visible = (
			cafes_bistro_actuales > 0
			and restaurantes_actuales == 0
		)

	if cafe_visual != null:
		cafe_visual.visible = (
			cafes_actuales > 0
			and cafes_bistro_actuales == 0
			and restaurantes_actuales == 0
		)


	# =========================================================
	# COMIDA
	# =========================================================

	if comida_visual != null:
		comida_visual.visible = comidas_actuales > 0


	# =========================================================
	# DEBUG
	# =========================================================

	print("☕ CAFÉS EN CIUDAD: ", cafes_actuales)
	print("🍔 COMIDAS EN CIUDAD: ", comidas_actuales)
	print("🥐 CAFÉS BISTRÓ EN CIUDAD: ", cafes_bistro_actuales)
	print("🍽️ RESTAURANTES EN CIUDAD: ", restaurantes_actuales)


# =========================================================
# BOTÓN VOLVER
# =========================================================

func _on_volver_pressed() -> void:
	print("⬅ VOLVER PRESIONADO")
	print("🏙️ CERRANDO CIUDAD")
	queue_free()
