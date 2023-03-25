extends Spatial

var buildPad
var targets = []
var detected = []
var furthestEnemy = null
var barrelPos
var shotCooldown = 2
var towerType = 2
var towerLevel = 1

onready var timer = get_node("Timer")
onready var anim = get_node("AnimationPlayer")
onready var towerRange = get_node("Area")
onready var shot = preload("res://Scenes/BombPathProjectile1.tscn")
onready var visibleRange = preload("res://Scenes/BombRange2.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(shotCooldown)
	barrelPos = global_translation + Vector3(0,3,0)
	towerRange.translation = translation
	var path = Path.new()
	add_child(path)

# Called every frame. 'delta' is the elapsed time since the previous frame.

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
	var enemyPos = furthestEnemy.get_parent().get_parent().translation
	anim.play("Shoot")
	var newShot = shot.instance()
	newShot.dmgMax = 18
	newShot.dmgMin = 9
	get_child(5).curve.clear_points()
	get_child(5).curve.add_point(Vector3(0, 4, 0), Vector3(0, -1, 0), Vector3(0, 16, 0), 0)
	get_child(5).curve.add_point(Vector3((enemyPos.x - global_translation.x)*1.2, 0.3, (enemyPos.z - global_translation.z)*1.2), Vector3(0, 7, 0), Vector3(0, -1, 0), 1)
	get_child(5).add_child(newShot)

func _on_Timer_timeout():
	if check_for_enemies() and !anim.is_playing():
		shoot_furthest_enemy()
	timer.start(shotCooldown)
		
