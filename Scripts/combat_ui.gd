extends Panel

#Establecer cuales son los botones
#ActionContainer es un vertical container que tiene como hijos todos los botones
@onready var buttons_container = $ActionsContainer
#Creamos un array que extraiga todos los botones del VBox
var action_buttons : Array[ActionButton]

@onready var description_text : RichTextLabel = $Description
#Cargamos el Script del GameManager que está en el Nodo Main
@onready var game_manager = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Inicializamos el description_text como vacío
	description_text.text = ""
	#Extraemos todos los botones hijos del ActionContainer
	for child in buttons_container.get_children():
		#Si el botón no tiene asignado el script ActionButton, lo omite y sigue
		if child is not ActionButton:
			continue
		#Si lo tiene asignado, lo insertamos al array
		action_buttons.append(child)
	
		#Conectamos las señales de entradas a la función asignada
		#Con bind le indicamos el argumento de entrada que le vamos a pasar a la función
		child.pressed.connect(_button_pressed.bind(child))
		child.mouse_entered.connect(_button_entered.bind(child))
		child.mouse_exited.connect(_button_exited.bind(child))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_combat_actions(actions : Array[CombatAction]):
	#Comprobamos que se despliega el número correcto de acciones
	for index in len(action_buttons):
		#Si el número de botones es mayor o igual a las acciones, se deshabilitan
		if index >= len(actions):
			action_buttons[index].visible = false
			continue
		
		#Hacemos visible el botón
		action_buttons[index].visible = true
		#Se asigna a cada botón su acción correspondiente
		action_buttons[index].set_combat_action(actions[index])
	

#Cuando se suelta el botón izquierdo del ratón
func _button_pressed(button : ActionButton):
	print("Pulsado el botón izquierdo")
	#Muestra la acción asignada desde el gameManager
	game_manager.player_combat_actions(button.combat_action)

#Cuando el ratón está sobre el botón
func _button_entered(button : ActionButton):
	print("El ratón está sobre el botón")
	#Cambia la descripción del botón solo cuando esté encima
	var action = button.combat_action
	description_text.text = "[b]" + action.name + "[/b]\n" + action.description
	

#Cuando el ratón sale del botón
func _button_exited(button : ActionButton):
	print("El cursor ha salido del botón")
	#Al salir ponemos el texto en blanco
	description_text.text = ""

#Señal para gestionar que pasa al pulsar sobre pasar turno
func _on_pass_turn_pressed() -> void:
	#Le asignamos la función del GameManager para apsar turno
	game_manager.next_turn()
