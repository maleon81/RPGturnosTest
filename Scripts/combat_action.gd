#Script que hereda de la clase Resource y que gestiona los recursos
#Lo vamos a usar como un script con las características comunes de los Pokémon
extends Resource
#El script tiene que ser usable por todos, por lo que le damos un nombre de clase
class_name CombatAction
#El nombre del Pokémon
@export var name : String
#Descripción de la acción
@export var description : String
#Cuando daño hará el ataque cuerpo a cuerpo
@export var melee_damage : int = 0
#Cuanta salud devolverá la poción o magia
@export var heal_amount : int = 0
#Posibilidad de la IA para hacer un ataque en concreto
@export var base_weight : int = 100
