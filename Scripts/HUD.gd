extends Control

var startingLives = 20
var startingMoney = 260
var lives = startingLives
var coins = startingMoney

var buildMode = false
var selectedTower = null
var towerRange = null
var towerCost = null


var Cannon = preload("res://Scenes/CannonLvl1.tscn")
var Cannon2 = preload("res://Scenes/CannonLvl2.tscn")
var cannonRange = preload("res://Scenes/CannonRange.tscn")
var cannonRange2 = preload("res://Scenes/CannonRange2.tscn")
var cannonPNG = load("res://Textures/CannonIcon.tres")
var Tesla = preload("res://Scenes/TeslaLvl1.tscn")
var teslaRange = preload("res://Scenes/TeslaRange.tscn")
var teslaPNG = load("res://Textures/TeslaIcon.tres")
var Tesla2 = preload("res://Scenes/TeslaLvl2.tscn")
var teslaRange2 = preload("res://Scenes/TeslaRange2.tscn")
var Bomb = preload("res://Scenes/BombTowerLvl1.tscn")
var Bomb2 = preload("res://Scenes/BombTowerLvl2.tscn")
var bombRange = preload("res://Scenes/BombRange.tscn")
var bombRange2 = preload("res://Scenes/BombRange2.tscn")
var bombPNG = load("res://Textures/BombIcon.tres")

var towers0 = [Tesla, Cannon, Bomb]
var towers1 = [Tesla2, Cannon2, Bomb2]
var towerLevels = [towers0, towers1]
var towerCosts0 = [70, 90, 130]
var towerCosts1 = [110, 125, 185]
var towerLevelCosts = [towerCosts0, towerCosts1]
var towerRanges0 = [teslaRange, cannonRange, bombRange]
var towerRanges1 = [teslaRange2, cannonRange2, bombRange2]
var towerRangeLevels = [towerRanges0, towerRanges1]
var fading = false

onready var hudLives = get_node("Health")
onready var hudCoins = get_node("Coins")
onready var charMode = get_node("BuildMode")
onready var mainChar = get_parent().get_node("MainChar")
onready var pauseButton = get_node("PauseButton")
onready var BuildOptions = get_node("BuildOptions")
onready var Spawner = get_parent().get_node("Path")
onready var startWaveButton = get_node("StartWave")
onready var waveNumber = get_node("Wave")
onready var errors = get_node("Errors")
onready var errorTimer = get_node("ErrorTimer")
onready var errorFade = get_node("ErrorFade")
onready var PerspectiveCamera = get_parent().get_node("CameraTracker/PerspectiveCamera")
onready var TopDownCamera = get_parent().get_node("CameraTracker/TopDownCamera")



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
	waveNumber.text = "Wave 0"

func _process(_delta):
	if fading:
		if errors.percent_visible > 0.01:
			errors.percent_visible -= 0.02

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_MIDDLE and event.is_pressed():
			_on_ChangeView_pressed()
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
		display_error_message("Not Enough Funds!")
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
	
func get_selected_tower():
	return [selectedTower, towerCost, towerRange]

	
func _on_PauseButton_toggled(_button_pressed):
	if pauseButton.pressed:
		get_tree().paused = true
	else:
		get_tree().paused = false


func _on_BuildOptions_item_selected(index):
	change_selected_tower(towers0[index], towerCosts0[index], towerRanges0[index])
	

func change_wave(wave):
	waveNumber.text = "Wave "+ str(wave)

func _on_BuildRemove_pressed():
	mainChar.build()


func _on_Remove_pressed():
	mainChar.remove()


func _on_Upgrade_pressed():
	mainChar.upgrade()

func display_error_message(error):
	errors.text = error
	errors.percent_visible = 1
	errorTimer.start(3)
	fading = false

func _on_ErrorTimer_timeout():
	errorFade.start(4)
	fading = true


func _on_ErrorFade_timeout():
	errors.text = ""
	fading = false

func _on_StartWave_button_up():
	Spawner.start_wave()


func _on_ChangeView_pressed():
	if PerspectiveCamera.is_current() == false:
		TopDownCamera.clear_current()
		PerspectiveCamera.make_current()
	else:
		PerspectiveCamera.clear_current()
		TopDownCamera.make_current()
