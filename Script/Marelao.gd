extends Node2D

# Declaração de Variáveis
var delay := 3.0
var timer := 0.0

var loser = preload("res://Imagens/Loser.png")
var new_loser = preload("res://Imagens/skull2.png")  # Nova imagem que vai cair a partir da fase 11

var active := []
var idle := []

var background_color := Color(1.0, 0.647, 0.0)  # Laranja (RGB: 1.0, 0.647, 0.0)
var target_color := Color(1.0, 0.0, 0.0)  # Vermelho (RGB: 1.0, 0.0, 0.0)
var transition_speed := 0.5  # A velocidade da transição de cor



# Inicializa o script quando a cena está pronta
func _ready():
	randomize()
	delay = lerp(3.0, 0.333, global.level / global.lastLevel)
	if global.level == global.lastLevel:
		delay = 0.15



# Atualiza o estado a cada frame
func _process(delta):
	timer -= delta
	
	# Verifica a transição de cor
	if global.level >= 11:
		background_color = background_color.lerp(target_color, transition_speed * delta)
		transition_speed = 1.0  # Acelera a transição quando o nível já for 11 ou maior
	
	# Aplica a cor de fundo
	self.modulate = background_color
	
	for i in active:
		i.position.y += 60.0 * delta
		if i.position.y > 160:
			idle.append(i)
	
	for i in idle:
		active.erase(i)
	
	if timer < 0:
		timer = delay
		var c
		if idle.size() > 0:
			c = idle.pop_back()
		else:
			c = Sprite2D.new()
			c.texture = loser
			c.z_index = -1
			add_child(c)
		active.append(c)
		c.position.y = -16
		c.position.x = randi_range(0, 144)
		
		# A partir da fase 11, usa a nova imagem
		if global.level >= 11:
			c.texture = new_loser
