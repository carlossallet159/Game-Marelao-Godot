extends Node2D

# Declaração de Variáveis
var tmpath := "res://TileMap/"
enum {TILE_WALL = 0, TILE_PLAYER = 1, TILE_GOOBER = 2}
var NodeTileMap

var ScenePlayer = load("res://Cenas/Player.tscn")
var SceneGoober = load("res://Cenas/Goober.tscn")
var SceneExplo = load("res://Cenas/Explosion.tscn")

@onready var NodeGoobers := $Goobers
@onready var NodeAudioWin := $Audio/Win
@onready var NodeAudioLose := $Audio/Lose
@onready var NodeSprite := $Sprite2D

var clock := 0.0
var delay := 1.5
var check := false
var change := false



# Função para iniciar o jogo
func _ready():
	global.Game = self
	
	if global.level == 0 or global.level == 21:
		NodeSprite.frame = 0 if global.level == 0 else 3
		NodeSprite.visible = true
		var p = ScenePlayer.instantiate()
		p.position = Vector2(72, 85)
		p.scale.x = -1 if randf() < 0.5 else 1
		p.set_script(null)
		add_child(p)
	
	MapLoad()
	MapStart()



# Função para gerenciar as fases
func _process(delta):
	clock += delta
	# title and finish
	if btn.p("jump") and (global.level == 0 or (global.level == 21  and clock > 0.5)):
		global.level = posmod(global.level + 1, 22)
		DoChange()
	
	MapChange(delta)



# Função para carregar os mapas (Tilemap)
func MapLoad():
	var nxtlvl = min(global.level, global.lastLevel)
	var tm = load(tmpath + str(nxtlvl) + ".tscn").instantiate()
	tm.name = "TileMap"
	add_child(tm)
	NodeTileMap = tm



# Função para iniciar o mapa após seu carregamento
func MapStart():
	print("--- MapStart: Começo ---")
	print("global.level: ", global.level)
	for pos in NodeTileMap.get_used_cells(0):
		var id = NodeTileMap.get_cell_source_id(0, pos)
		if id == TILE_WALL:
			print(pos, ": Wall")
		elif id == TILE_PLAYER or id == TILE_GOOBER:
			var p = id == TILE_PLAYER
			print(pos, ": Player" if p else ": Goober")
			var inst = (ScenePlayer if p else SceneGoober).instantiate()
			inst.position = NodeTileMap.map_to_local(pos) + Vector2(4, 0 if p else 1)
			(self if p else NodeGoobers).add_child(inst)
			# remove tile from map
			NodeTileMap.set_cell(0, pos, -1)
	print("--- MapStart: Fim ---")



# Função para gerenciar a transição das fases "Calmas" para as fases "Trevosas"
func MapChange(delta):
	if change:
		delay -= delta
		if delay < 0:
			DoChange()
		return
	
	if check:
		check = false
		var count = NodeGoobers.get_child_count()
		print("Goobers: ", count)
		if count == 0:
			Win()



# Função que cuida da derrota do jogador
func Lose():
	change = true
	NodeAudioLose.play()
	NodeSprite.visible = true
	NodeSprite.frame = 2
	global.level = max(0, global.level - 1)



# Função que cuida da vitória do jogador
func Win():
	change = true
	NodeAudioWin.play()
	NodeSprite.visible = true
	global.level = min(global.lastLevel, global.level + 1)
	print("Level completo! Mudando para o level: ", global.level)



# Função para carregar a cena atual
func DoChange():
	change = false
	get_tree().reload_current_scene()



# Função da explosão
func Explode(arg : Vector2):
	var xpl = SceneExplo.instantiate()
	xpl.position = arg
	add_child(xpl)
