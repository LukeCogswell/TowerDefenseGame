extends Path

var crawlertimer = 0
var tanktimer = 0
var crawlerSpawnTime = 1
var tankSpawnTime = 10
var spawning = false
var wave_length = 10
var lastWave = 20
var wave = 0
var wave_timeout = 5
var crawlerMinSpawnTime = 0.2
var tankMinSpawnTime = 3

var crawler = preload("res://Scenes/Crawler.tscn")
var tank = preload("res://Scenes/Tank.tscn")

onready var waveTimer = get_node("WaveLength")
onready var HUD = get_parent().get_node("HUD")
onready var waveTimeout = get_node("WaveTimeout")

# Called when the node enters the scene tree for the first time.
func _ready():
	HUD.lastWave = lastWave


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if spawning:
		crawlertimer += delta
		tanktimer += delta
	
	if crawlertimer > crawlerSpawnTime:
		var newCrawler = crawler.instance()
		add_child(newCrawler)
		crawlertimer = 0
		
	if tanktimer > tankSpawnTime:
		var newTank = tank.instance()
		add_child(newTank)
		tanktimer = 0

func start_wave():
	spawning = true
	crawlertimer = 0
	tanktimer = 0
	wave += 1
	waveTimer.start(wave_length)
	wave_length = (wave + 1) * 5
	HUD.change_wave(wave)

func _on_WaveLength_timeout():
	if wave > 3:
		crawlerSpawnTime = 0.5
	if wave > 5:
		tankSpawnTime = 5
	if wave > 10:
		crawlerSpawnTime /= 2
		tankSpawnTime /= 2
	if crawlerSpawnTime < crawlerMinSpawnTime:
		crawlerSpawnTime = crawlerMinSpawnTime
	if tankSpawnTime < tankMinSpawnTime:
		tankSpawnTime = tankMinSpawnTime
	spawning = false
	waveTimeout.start(5)



func _on_WaveTimeout_timeout():
	HUD.enable_next_wave_button()
