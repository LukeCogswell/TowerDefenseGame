extends KinematicBody

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var destination : Vector3
var path = []
var targets = []
var detected = []
var LMouseButtonIsPressed = false
var buildMode = false
var clickPos
var buildPad = null
var result
var selectedTower = null
var furthestEnemy : Area
var clicked_build_pad = null
var towerCost = 999999
var towerRange = null

onready var shot = preload("res://Scenes/MainCharProjectile.tscn")
onready var navAgent : NavigationAgent
onready var character = get_node("MainCharacter")
onready var anim = get_node("MainCharacter/AnimationPlayer")
onready var char_range = get_node("CharacterRange")
onready var buildPads = get_parent().get_node("BuildPads")
onready var rangeDisplay = get_node("MainCharacter/RangeDisplay")
onready var hud = get_parent().get_node("HUD")
onready var TowerRanges = get_parent().get_node("TowerRange")

#onready var overlapping_areas = get_parent().get_node("Path/PathFollow/KinematicBody/Area")
# Called when the node enters the scene tree for the first time.
func _ready():
	navAgent = $NavigationAgent
	character.translation.x = -150 

func _process(_delta):
	if buildMode == false:
		if LMouseButtonIsPressed and !anim.is_playing() and check_for_enemies():
			shoot_furthest_enemy()
			destination = character.translation

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			LMouseButtonIsPressed = true
			if buildMode:
				get_buildPad_clicked()
		elif event.button_index == 1 and not event.is_pressed():
			LMouseButtonIsPressed = false
		if event.button_index == 2 and event.is_pressed():
			if ScreenPointToRay():
				navAgent.set_target_location(result["position"])
				destination = navAgent.get_final_location()
				path = navAgent.get_nav_path()
				destination.y = 0
	elif event is InputEventKey:
		if event.scancode == KEY_B and event.is_pressed():
			toggle_buildMode()

func _physics_process(delta):
	var direction = Vector3()
	var step_size = delta * 100
	if anim.is_playing() and is_instance_valid(furthestEnemy):
		character.look_at_from_position(character.translation, furthestEnemy.get_parent().get_parent().translation, Vector3.UP)
		character.rotate_y(PI)
	if path.size() > 0 and !anim.is_playing():
		direction = destination - character.translation
		if step_size > direction.length():
			step_size = direction.length()
			path.remove(0)
		character.translation += direction.normalized() * step_size
		direction.y = 0
		
		if direction:
			var look_at_direction = direction + character.translation
			character.look_at_from_position(character.translation, look_at_direction, Vector3.UP)
			character.rotate_y(PI)

func ScreenPointToRay():
	result = null
	var spaceState = get_world().direct_space_state
	
	var camera = get_tree().root.get_camera()
	var mousePos = get_viewport().get_mouse_position()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd  = rayOrigin + camera.project_ray_normal(mousePos) * 2000
	result = spaceState.intersect_ray(rayOrigin, rayEnd)
	if result.has("position"):
		return result["position"]
	return Vector3()

func check_for_enemies():
	detected = char_range.get_overlapping_areas()
	var i = 0
	targets = []
	while i < detected.size():
		if detected[i].get_parent().get_parent().get_class() == "PathFollow" and detected[i].get_parent().get_parent().dead == false:
			targets.append(detected[i])
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
	character.look_at_from_position(character.translation, furthestEnemy.get_parent().get_parent().translation, Vector3.UP)
	character.rotate_y(PI)
	anim.play("Shoot")
	var newShot = shot.instance()
	newShot.target = furthestEnemy
	newShot.targetNodePath = furthestEnemy.get_path()
	newShot.translation = character.global_translation + Vector3(0, 4.502, 0)
	add_child(newShot)

func get_buildPad_clicked():
	
	if LMouseButtonIsPressed:
		var j = 0
		if !ScreenPointToRay():
			return false
		buildPad = null
		while j < buildPads.get_children().size():
			if result["collider"].get_parent() == buildPads.get_child(j):
				buildPad = buildPads.get_child(j)
			j += 1
		if buildPad:
			show_tower_range()
			return true
		else: 
			hide_tower_range()
			return false

func pad_has_tower(pad):
	if pad.get_child_count() > 2:
		return true
	else:
		return false

func toggle_buildMode():
	buildMode = not buildMode
	rangeDisplay.visible = not rangeDisplay.visible
	if hud.buildMode != buildMode:
		hud.toggle_build_mode()

func build_tower_on_pad(pad):
	if selectedTower:
		var newTower = selectedTower.instance()
		newTower.buildPad = pad
		character.look_at_from_position(character.translation, buildPad.global_translation, Vector3.UP)
		character.rotate_y(PI)
		anim.play("Build")
		pad.add_child(newTower)

func show_tower_range():
	hide_tower_range()
	if buildPad:
		if TowerRanges.get_child_count() > 0:
			TowerRanges.get_child(0).queue_free()
		if buildPad.get_child_count() <= 2:
			var newRange = towerRange.instance()
			newRange.buildPad = buildPad
			TowerRanges.add_child(newRange)
		else:
			var newRange = buildPad.get_child(2).visibleRange.instance()
			newRange.buildPad = buildPad
			TowerRanges.add_child(newRange)

func hide_tower_range():
	if TowerRanges.get_child_count() > 0:
		TowerRanges.get_child(0).queue_free()

func build():
	if buildPad:
		if TowerRanges.get_child_count() > 0:
			TowerRanges.get_child(0).queue_free()
		if !pad_has_tower(buildPad):
			if !anim.is_playing():
				if hud.use_money(towerCost):	
					build_tower_on_pad(buildPad)

func remove():
	if buildPad:
		if TowerRanges.get_child_count() > 0:
			TowerRanges.get_child(0).queue_free()
		if pad_has_tower(buildPad):
			buildPad.get_child(2).queue_free()
