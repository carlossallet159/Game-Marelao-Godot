extends Node

# Converte um valor booleano em 1 (se true) ou 0 (se false)
func NumBool(arg : bool):
	return 1 if arg else 0

# Verifica se a ação especificada está sendo pressionada no momento
func d(arg : String):
	return NumBool(Input.is_action_pressed(arg))

# Verifica se a ação especificada foi pressionada (no frame atual)
func p(arg : String):
	return NumBool(Input.is_action_just_pressed(arg))

# Verifica se a ação especificada foi liberada (no frame atual)
func r(arg : String):
	return NumBool(Input.is_action_just_released(arg))
