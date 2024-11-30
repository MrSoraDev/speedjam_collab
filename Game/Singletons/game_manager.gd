extends Node


#var nome_dos_dict: Dictionary = {
	#
#}

var Scores: Dictionary = {
	"Nivel 1": 0
}

func set_score(nome_da_fase:String, level_time) -> void:
	if nome_da_fase in Scores:
		Scores[nome_da_fase] = level_time
		
func get_score(nome_da_fase:String, level_time) -> float:
	if nome_da_fase in Scores:
		return Scores[nome_da_fase]
	else:
		return 0
