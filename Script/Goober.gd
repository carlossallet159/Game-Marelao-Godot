extends CharacterBody2D
class_name Goober

# Declaração de Variáveis
@onready var NodeCast := $RayCast2D
@onready var NodeSprite := $Sprite2D

var spd := 30.0
var vel := Vector2(spd, 0.001)
var flip_clock := 1.0



# Inicia o Goober (inimigo) quando a cena está pronta
func _ready():
	randomize()
	if randf() > 0.5:
		flip()



# Função para atualizar o estado físico do Goober a cada frame (física)
func _physics_process(delta):
	flip_clock += delta
	
	if !NodeCast.is_colliding():
		flip()
	
	velocity = vel
	move_and_slide()
	if velocity.x == 0:
		flip()
	
	position = global.wrapp(position)



# Animação do Glooper, invertendo as direções
func flip():
	if flip_clock < 0.1: return
	vel.x = -vel.x
	NodeSprite.flip_h = !NodeSprite.flip_h
	flip_clock = 0.0
