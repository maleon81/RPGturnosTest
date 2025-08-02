extends Node2D

#Definimos el nodo del Player
@export var player_character : Player
#Definimos el nodo de la IA
@export var ia_character : Player
#Qué personajes está luchando en ese momento
var current_character : Player

@onready var player_ui = $CanvasLayer/CombatUI

#Saber si el juego ha terminado
var game_over : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	next_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#Se encarga de gestionar los turnos
func next_turn():
	#Lo que pasa al acabar la partida
	if game_over:
		#Si game_over == true, salimos de la función
		return
	
	#Si current_character no es null, se termina el turno
	if current_character != null:
		current_character.end_turn()
	#Si current_character es la IA o no hay nada, pasamos al Player. 
	#En caso contrario, pasamos a la IA
	if current_character == ia_character or current_character == null:
		current_character = player_character
	else:
		current_character = ia_character
	
	current_character.begin_turn()
	
	#Gestionamos si current_character es Player o la IA
	if current_character.is_player:
		#Mostramos la interfaz
		player_ui.visible = true
		#Asignamos los botones
		player_ui.set_combat_actions(player_character.combat_actions)
		#Probamos que pasa de un turno a otro
		#await get_tree().create_timer(0.5).timeout
		#next_turn()
		pass
	#Contemplamos que es el turno de la IA
	else:
		#Hay que desactivar la interfaz
		player_ui.visible = false
		#Hay que esperar un tiempo (aleatorio) para las decisiones de la IA.
		var wait_time = randf_range(0.5 , 1.5)
		await get_tree().create_timer(wait_time).timeout
		#Implementamos el ataque de la IA
		var action_to_ia = ai_decide_combat_actions()
		ia_character.cast_combat_action(action_to_ia, player_character) 
		await get_tree().create_timer(0.5).timeout
		next_turn()
	
	#Gestionamos la interfaz del Player
	

#Gestiona los turnos del Player
func player_combat_actions(action : CombatAction):
	#Si no es el turno del Player, salimos de la función
	if player_character != current_character:
		return
	
	#Definimos la acción y a quién se ataca
	player_character.cast_combat_action(action, ia_character)
	
	#Se desactiva la interfaz del Player porque ya se ha realizado la acción
	player_ui.visible = false
	#Creamos un timer para que espere un tiempo para pasar al siguiente turno
	await get_tree().create_timer(0.5).timeout
	
	#Al acabar, se pasa al siguiente turno
	next_turn()

#Gestiona los turnos de la IA
#Función de tipo return que devuelve un valor
func ai_decide_combat_actions() -> CombatAction:
	#Si no es el turno de la IA, que no entre en la función
	if ia_character != current_character:
		return
	
	#1º ESTABLECER las variables
	#Variables locales para no modificar las globales
	var ia = ia_character
	var player = player_character
	#Guardamos las acciones de la IA
	var actions = ia.combat_actions
	#Extraer el base_weight de cada acción con un array
	var array_weights : Array[int] = []
	#Variable para almacenar la suma de todos los valores de base_weight (suma de probabilidades)
	var total_weights = 0
	
	
	#2º CALCULAR el porcentaje de salud que tienen el Player y la IA
	#Variables para guardar los porcentajes de salud
	#Hay que calcularlo com porcentaje. Obligamos el tipo de variable (float) con casting
	var ia_health_perc = float(ia.current_health) / float(ia.max_health)
	var player_health_perc = float(player.current_health) / float(player.max_health)
	
	#3º ASIGNAR el base weight y MODIFICARLO en función de la cantidad de salud
	#Usamos un for para guardar las acciones en action_item
	for action_item in actions:
		#Se extraen los base_weight de cada accion y se guardan en weight
		var weight : int = action_item.base_weight
		
		#Si la salud del personaje es menor o igual que la cantidad de daño de la acción del
		#bucle for, multiplicamos por 3 la probabilidad de esa acción
		if player.current_health <= action_item.melee_damage:
			weight *= 3
		
		#Si la acción dentro del bucle puede recuperar vida, aumentaremos la probabilidad
		#de usarla en función de la vida que tenga la ia
		if action_item.heal_amount > 0:
			weight *= 1 + (1 - ia_health_perc)
		
		#Añadimos las probabilidades al array auxiliar array_weights que guarda las
		#base_weights de cada acción
		array_weights.append(weight)
		print("Weight: " + str(weight))
		#Por cada iteración, sumamos las base_weights
		total_weights += weight
	print("Total Weight: " + str(total_weights))
	
	#4º ELEGIR la acción, aleatoria, en función de la probabilidad calculada
	#Cantidad de probabilidad acumulada
	var cumulative_weight = 0
	#Hacemos un aleatorio en base a los weights
	var rand_weight = randi_range(0 , total_weights)
	
	#Creamos un bucle para seleccionar la acción a usar
	#Dará tantas vueltas como acciones hayan
	for index in len(actions):
		cumulative_weight += array_weights[index]
		
		print("Cumulative Weight: " + str(cumulative_weight))
		print("Número Aleatorio: " + str(rand_weight))
		
		#Si el valor generado aleatoriamente es menor que el acumulado en el 
		#primer cajón de probabilidades
		if rand_weight < cumulative_weight:
			#Si se cumple esta condición, elegimos esa acción
			print(actions[index].name)
			return actions[index]
	
	return null
