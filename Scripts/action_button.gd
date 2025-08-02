extends Button

class_name ActionButton

#Acción que correcponde a este botón
var combat_action : CombatAction


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#Configura el botón correspondiente
func set_combat_action(action : CombatAction):
	combat_action = action
	text = action.name
