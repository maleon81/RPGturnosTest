extends Node2D

class_name Character

#Señal que gestiona el daño => La variable health reducirá o aumentará su valor
signal OnTakeDamage(health : int)
#Señal que gestiona la salud
signal OnHeal(health : int)

#VARIABLES
#Para saber quien usa el nodo (jugador o IA)
@export var is_player : bool
#La salud del Player actual
@export var current_health : int
#La salud del Player máxima
@export var max_health : int

#Array de acciones de combate
@export var combat_actions : Array[CombatAction]

#Gestionar la escala del personaje para que se vea más grande
var target_scale : float = 1.0

#Para cambiar el sprite
#Se crea una variable para introducir el Sprite que corresponde (Player o IA)
@export var display_texture : Texture2D
#Sobre cuál nodo se va a modificar la textura
@onready var sprite : Sprite2D = $CharacterSprite

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

#Sonido de daño
var take_damage_sound : AudioStream = preload("res://Assets/Audio/take_damage.wav")
#Sonido de sanar
var heal_sound : AudioStream = preload("res://Assets/Audio/heal.wav")

func _ready() -> void:
	#Asignamos el sprite que corresponde
	sprite.texture = display_texture

func _process(delta: float) -> void:
	#Se modifica la escala del character al inicio del turno
	scale.x = lerp(scale.x, target_scale, delta * 10)
	scale.y = lerp(scale.y, target_scale, delta * 10)

#Iniciar el turno del Player
func begin_turn():
	#Escala mayor al iniciar
	target_scale = 1.05
	
	if is_player:
		print("Comienza el turno del Player")
	else:
		print("Comienza el turno de la IA")

#Terminar el turno del Player
func end_turn():
	#La escala vuelve a la normalidad
	target_scale = 0.97

#Recibir daño
func take_damage(amount : int):
	#Restamos a la vida la cantidad de daño realizada en la acción
	current_health -= amount
	OnTakeDamage.emit(current_health)
	play_audio(take_damage_sound)

#Curar daño
func heal(amount : int):
	current_health += amount
	#Usamos la funcion clamp para limitar la cantidad de curación máxima que puede haber
	current_health = clamp(current_health, 0 , max_health)
	OnHeal.emit(current_health)
	play_audio(heal_sound)

#Gestionar las acciones de combate (quien la realiza , a quien la realiza)
func cast_combat_action(action : CombatAction, opponent : Character):
	#Si no se ejecuta acción, salimos de la función
	if action == null:
		return
	#Si mele_damge es mayor que cero, el oponente recibirá el daño almacenado en la variable
	if action.melee_damage > 0:
		opponent.take_damage(action.melee_damage)
	#Hacemos lo mismo si hay cura, pero llamando a la función heal
	if action.heal_amount > 0:
		heal(action.heal_amount)

#Reproducir el audio
func play_audio(stream : AudioStream):
	audio.stream = stream
	audio.play()
