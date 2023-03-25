extends Path

var crawlertimer = 0
var tanktimer = 0
var crawlerSpawnTime = 1
var tankSpawnTime = 10
var spawning = false
var wave_length = 10
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
	pass

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

func _unhandled_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_N and event.is_pressed():
			start_wave()

func start_wave():
	HUD.startWaveButton.disabled = true
	spawning = true
	crawlertimer = 0
	tanktimer = 0
	wave += 1
	waveTimer.start(wave_length)
	wave_length = (wave + 1) * 4
	HUD.change_wave(wave)

func _on_WaveLength_timeout():
	if wave > 3:
		crawlerSpawnTime = 0.75
	if wave > 5:
		tankSpawnTime = 5
	if wave > 10 && wave % 3 == 0:
		crawlerSpawnTime /= 2
		tankSpawnTime /= 2
	if crawlerSpawnTime < crawlerMinSpawnTime:
		crawlerSpawnTime = crawlerMinSpawnTime
	if tankSpawnTime < tankMinSpawnTime:
		tankSpawnTime = tankMinSpawnTime
	spawning = false
	HUD.startWaveButton.disabled = false


func _on_WaveTimeout_timeout():
	pass # Replace with function body.
