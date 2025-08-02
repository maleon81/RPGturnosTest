extends ProgressBar
#A través de la variable llamaremos al nodo padre para acceder a sus elementos
var character = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#El nodo padre de HealthBar
	character = get_parent()
	max_value = character.max_health
	update_value(character.current_health)
	
	#Conectamos las señales de Player de daño y curación para actualizar la vida
	character.OnTakeDamage.connect(update_value)
	character.OnHeal.connect(update_value)


#Actualizamos el valor de la barra de vida
func update_value(health : int):
	#Usamos la variable value que es inherente al nodo ProgressBar
	value = health
