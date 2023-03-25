extends Spatial

var buildPad
var targets = []
var detected = []
var furthestEnemy = null
var shotCooldown = 0.43
var dmg = 8
var towerType = 0
var towerLevel = 1

onready var timer = get_node("Timer")
onready var anim = get_node("AnimationPlayer")
onready var towerRange = get_node("Area")
onready var shot = preload("res://Scenes/TeslaBolt1.tscn")
onready var visibleRange = preload("res://Scenes/TeslaRange2.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("Build")
	timer.start(shotCooldown)
	towerRange.translation = translation

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func check_for_enemies():
	detected = towerRange.get_overlapping_areas()
	var i = 0
	targets = []
	while i < detected.size():
		if detected[i].get_parent().get_parent().get_class() == "PathFollow":
			if detected[i].get_parent().get_parent().dead == false:
				targets.append(detected[i])
				i += 1
				continue
			else:
				i += 1
				continue
		else:
			i += 1
			continue
	if targets:
		return true
	return false

func shoot_furthest_enemy():
	var i = 0
	furthestEnemy = targets[0]
	while i < targets.size():
		if is_instance_valid(furthestEnemy):
			if furthestEnemy.get_parent().get_parent().get_unit_offset() < targets[i].get_parent().get_parent().get_unit_offset():
				furthestEnemy = targets[i]
		i += 1
	var newShot = shot.instance()
	newShot.set_translation(translation + Vector3(0, 9, 0))
	newShot.target = furthestEnemy
	newShot.dmg = dmg
	newShot.targetNodePath = furthestEnemy.get_path()
	add_child(newShot)


func _on_Timer_timeout():
	if check_for_enemies() and !anim.is_playing():
		shoot_furthest_enemy()
	timer.start(shotCooldown)
		
