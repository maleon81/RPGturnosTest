extends Sprite2D

var character = null

#Usamos 2 variables para generar un movimiento senoidal del personale
#Subir y bajar
var swing_amount : float = 0.04
#Velocidad
var move_speed : float = 10.0

#Usamos 3 variables para crear la vibración
#Primero se almacena el offset actual
@onready var base_offset : Vector2 = offset
#La intensidad del temblor
var shake_intensity : float = 0.0
#La amortiguación del temblor para evitar brusquedad
var shake_damping : float = 10.0

#Añadimos efectos de golpes
func _ready() -> void:
	#Cargamso el nodo
	character = get_parent()
	#Usamos la señal de daño para llamar a los efectos
	character.OnTakeDamage.connect(visual_effects_damage)
	character.OnHeal.connect(visual_effects_heal)

func _process(delta: float) -> void:
	#Movimiento de subir y bajar
	#Obtener el tiempo en segundos
	var time = Time.get_unix_time_from_system()
	#Hayq ue recordar que tenemos la escala en 2 y que queremos que se mueva en positivo
	var y_scale = 2 + (sin(time * move_speed) * swing_amount)
	scale.y = y_scale
	
	#Temblor al ser golpeados
	if shake_intensity > 0:
		shake_intensity = lerpf(shake_intensity, 0, shake_damping * delta)
		#Si hiciéramos offset += random_offset() no volvería a su posición inicial
		offset = base_offset + random_offset()

#Hacemos modificaciones al Sprite dependiendo de lo que suceda
func visual_effects_damage(health : int):
	modulate = Color.CORAL
	shake_intensity = 10.0
	await get_tree().create_timer(0.2).timeout
	modulate = Color.WHITE

func visual_effects_heal(health : int):
	modulate = Color.DARK_TURQUOISE
	await get_tree().create_timer(0.2).timeout
	modulate = Color.WHITE

#Creamos una función para controlar el offset de manera aleatoria (desordenada)
func random_offset() -> Vector2:
	var x = randf_range(-shake_intensity, shake_intensity)
	var y = randf_range(-shake_intensity, shake_intensity)
	return Vector2(x, y)
