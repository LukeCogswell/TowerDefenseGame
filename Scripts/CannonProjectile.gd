extends Area

export var speed = 70

enum{
	electric, physical
	}

var dead = false
var direction = Vector3()
var target
var targetNodePath
var impacted = false

var dmg
var dmgMin = 14
var dmgMax = 26
var dmgType = physical
onready var timer = get_node("Timer")
onready var mesh = get_node("MeshInstance2")

func _ready():
	dmg = randi() % (dmgMax - dmgMin) + dmgMin

func _physics_process(delta):
	if !impacted:
		if get_node_or_null(targetNodePath):
			if target.get_parent().get_parent().dead:
				queue_free()
			direction = target.global_translation - global_translation + Vector3(0, 2, 0)
			translation += direction.normalized() * delta * speed
			if direction:
				var look_at_direction = direction + global_translation
				look_at(look_at_direction, Vector3.UP)
	if !get_node_or_null(targetNodePath):
		queue_free()



func _on_Timer_timeout():
	queue_free()

func _on_Particle_area_entered(area):
	if area == target:
		target.get_parent().get_parent().hit(dmg, dmgType)
		impacted = true
		queue_free()
