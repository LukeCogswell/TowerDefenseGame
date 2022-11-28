extends Control

var startingLives = 20
var startingMoney = 400
var lives = startingLives
var coins = startingMoney

var buildMode = false
var selectedTower = null
var towerRange = null
var towerCost = null

var lastWave = 20

var Cannon = preload("res://Scenes/CannonLvl1.tscn")
var cannonRange = preload("res://Scenes/CannonRange.tscn")
var cannonPNG = load("res://Textures/CannonIcon.tres")
var Tesla = preload("res://Scenes/TeslaLvl1.tscn")
var teslaRange = preload("res://Scenes/TeslaRange.tscn")
var teslaPNG = load("res://Textures/TeslaIcon.tres")
var Bomb = preload("res://Scenes/BombTowerLvl1.tscn")
var bombRange = preload("res://Scenes/BombRange.tscn")
var bombPNG = load("res://Textures/BombIcon.tres")

var towers = [Tesla, Cannon, Bomb]
var towerCosts = [70, 90, 130]
var towerRanges = [teslaRange, cannonRange, bombRange]

onready var hudLives = get_node("Health")
onready var hudCoins = get_node("Coins")
onready var charMode = get_node("BuildMode")
onready var mainChar = get_parent().get_node("MainChar")
onready var pauseButton = get_node("PauseButton")
onready var BuildOptions = get_node("BuildOptions")
onready var Spawner = get_parent().get_node("Path")
onready var startWaveButton = get_node("StartWave")
onready var waveNumber = get_node("Wave")



# Called when the node enters the scene tree for the first time.
func _ready():
	BuildOptions.add_icon_item(teslaPNG, "$70")
	BuildOptions.add_icon_item(cannonPNG, "$90")
	BuildOptions.add_icon_item(bombPNG, "$130")
	BuildOptions.selected = 0
	selectedTower = Tesla
	towerRange = teslaRange
	towerCost = 70
	mainChar.selectedTower = selectedTower
	mainChar.towerCost = towerCost
	mainChar.towerRange = towerRange
	hudCoins.text = "$" +  str(coins)
	waveNumber.text = "Wave 0/" + str(lastWave)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.scancode == KEY_ESCAPE and event.is_pressed():
			get_tree().quit()

func toggle_build_mode():
	buildMode = not buildMode
	mainChar.hide_tower_range()
	charMode.pressed = buildMode

func use_money(money):
	if coins - money < 0:
		hudCoins.text = "$" +  str(coins)
		return false
	else:
		coins -= money
		hudCoins.text = "$" + str(coins)
		return true

func add_money(money):
	coins += money
	hudCoins.text = "$" + str(coins)

func dmg(dmg):
	lives -= dmg
	hudLives.text = str(lives)
	if lives <= 0:
		get_tree().quit()

func _on_Mode_toggled(_button_pressed):
	if buildMode != charMode.pressed:
		buildMode = not buildMode
	if mainChar.buildMode != buildMode:
		mainChar.toggle_buildMode()
	mainChar.hide_tower_range()

func change_selected_tower(tower, cost, rangeArea):
	selectedTower = tower
	towerCost = cost
	towerRange = rangeArea
	mainChar.selectedTower = selectedTower
	mainChar.towerCost = towerCost
	mainChar.towerRange = towerRange
	mainChar.show_tower_range()
	

func enable_next_wave_button():
	startWaveButton.disabled = false
	
	
func _on_PauseButton_toggled(_button_pressed):
	if pauseButton.pressed:
		get_tree().paused = true
	else:
		get_tree().paused = false


func _on_BuildOptions_item_selected(index):
	change_selected_tower(towers[index], towerCosts[index], towerRanges[index])
	

func _on_StartWave_pressed():
	startWaveButton.disabled = true
	Spawner.start_wave()	

func change_wave(wave):
	waveNumber.text = "Wave "+ str(wave) +"/"+str(lastWave)

func _on_BuildRemove_pressed():
	mainChar.build()


func _on_Remove_pressed():
	mainChar.remove()
