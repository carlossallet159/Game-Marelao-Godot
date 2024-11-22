extends Node2D

# Declaração de Variáveis
var level := 0
var lastLevel := 21
var Game
var audio



# Função para iniciar o jogo quando a cena estiver pronta
func _ready():
	await get_tree().create_timer(0.1).timeout
	
	audio = AudioStreamPlayer.new()
	add_child(audio)
	audio.play()
	audio.finished.connect(audio.play)



# Função para atualizar os frames e verifica as condições para passar as fases
func _input(event):
	if event.is_action_pressed("ui_fullscreen"):
		var win_full = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE if win_full else DisplayServer.MOUSE_MODE_HIDDEN)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED if win_full else DisplayServer.WINDOW_MODE_FULLSCREEN)

func wrapp(pos := Vector2.ZERO):
	return Vector2(wrapf(pos.x, 0.0, 144.0), wrapf(pos.y, 0.0, 144.0))
