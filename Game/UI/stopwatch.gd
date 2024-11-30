extends Node2D
class_name Stopwatch

var time = 0.0
var stopped = false


func _process(delta: float) -> void:
	if stopped:
		return
	time += delta

func reset():
	time = 0.0

func time_to_string() -> String:
	var msec = fmod(time,1) * 1000 #fmod retorna o float que sobra da divisao de x e y
	var sec = fmod(time,60) #chegou a 60 segundos ja deu um min
	var minut = time / 60 
	var format_string = "%02d : %02d : %02d"
	var actual_string = format_string % [minut, sec ,msec]
	return actual_string
