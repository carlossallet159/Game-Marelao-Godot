extends CharacterBody2D

# Declaração de Variáveis
@onready var NodeScene = global.Game
@onready var NodeSprite := $Sprite2D
@onready var NodeArea2D := $Area2D
@onready var NodeAudio := $Audio
@onready var NodeAnim := $AnimationPlayer

var vel := Vector2.ZERO
var spd := 60.0
var grv := 255.0
var jumpSpd := 133.0
var termVel := 400.0

var onFloor := false
var jump := false

var screen_bottom := 144  # A altura da tela (modifique conforme necessário para o seu jogo)



#Atualiza o estado físico do jogador a cada frame de física
func _physics_process(delta):
	# gravity
	vel.y += grv * delta
	vel.y = clamp(vel.y, -termVel, termVel)
	
	# horizontal input
	var btnx = btn.d("right") - btn.d("left")
	vel.x = btnx * spd
	
	# jump
	if onFloor:
		if btn.p("jump"):
			jump = true
			vel.y = -jumpSpd
			NodeAudio.play()
	elif jump:
		if !btn.d("jump") and vel.y < jumpSpd / -3:
			jump = false
			vel.y = jumpSpd / -3
	
	# apply movement
	velocity = vel
	move_and_slide()

	# Verifica se o personagem caiu fora da tela (abaixo da tela)
	if position.y > screen_bottom:
		Die()
	
	# check for Goobers
	var hit = Overlap()  # Chama a função Overlap corretamente
	if !hit:
		if velocity.y == 0:
			vel.y = 0
		# check for floor 0.1 pixel down
		onFloor = test_move(transform, Vector2(0, 0.1))
	
	# sprite flip
	if btnx != 0:
		NodeSprite.flip_h = btnx < 0
	
	# animação
	if onFloor:
		if btnx == 0:
			TryLoop("Idle")  # Chama a função TryLoop corretamente
		else:
			TryLoop("Run")  # Chama a função TryLoop corretamente
	else:
		TryLoop("Jump")  # Chama a função TryLoop corretamente



# Executa a lógica quando o jogador morrer
func Die():
	queue_free()
	NodeScene.Explode(position)
	NodeScene.Lose()  # Chama a função Lose() para diminuir o nível ou reiniciar o jogo




# Função que verifica se o personagem está sobrepondo outro objeto (Goober)
func Overlap() -> bool:
	var hit = false
	
	for o in NodeArea2D.get_overlapping_areas():
		var par = o.get_parent()
		print("Overlapping: ", par.name)
		
		if par is Goober:
			var above = position.y - 1 < par.position.y
			
			if onFloor or (vel.y < 0.0 and !above):
				Die()
			else:
				hit = true
				jump = btn.d("jump")
				vel.y = -jumpSpd * (1.0 if jump else 0.6)
				
				par.queue_free()
				NodeScene.Explode(par.position)
				NodeScene.check = true
				print("Goober destroyed")
	return hit



# Função que controla as animações do personagem
func TryLoop(arg: String) -> bool:
	if arg == NodeAnim.current_animation:
		return false
	else:
		NodeAnim.play(arg)
		return true
