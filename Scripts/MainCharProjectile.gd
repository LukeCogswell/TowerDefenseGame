extends Area

export var speed = 50

var dead = false
var direction = Vector3()
var target
var targetNodePath
var impacted = false

var dmgMin = 3
var dmgMax = 7
var dmg
var dmgType = electric

enum{
	electric, physical
	}

onready var timer = get_node("Timer")
onready var mesh = get_node("MeshInstance")

func _ready():
	dmg = randi() % (dmgMax - dmgMin) + dmgMin
	mesh.get_surface_material(0).albedo_color = Color("509ce7")
	

func _physics_process(delta):
	if !impacted:
		if get_node_or_null(targetNodePath):
			direction = target.global_translation - global_translation + Vector3(0, 2, 0)
			translation += direction.normalized() * delta * speed
			if direction:
				var look_at_direction = direction + global_translation
				look_at(look_at_direction, Vector3.UP)
			if target.get_parent().get_parent().dead == true:
				queue_free()
		if !get_node_or_null(targetNodePath):
			queue_free()



func _on_Timer_timeout():
	mesh.get_surface_material(0).albedo_color = Color("509ce7")
	queue_free()

func _on_Particle_area_entered(area):
	if area == target:
		target.get_parent().get_parent().hit(dmg, dmgType)
		impacted = true
		mesh.get_surface_material(0).albedo_color = Color("bb5c2e")
		timer.start(0.1)
