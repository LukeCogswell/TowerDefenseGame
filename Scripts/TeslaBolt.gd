extends Area

export var speed = 150

enum{
	electric, physical
	}

var dead = false
var direction = Vector3()
var target
var targetNodePath
var impacted = false

var dmgMin = 6
var dmgMax = 13
var dmg

var dmgType = electric
onready var timer = get_node("Timer")
onready var mesh = get_node("LightningBolt/Cylinder")

func _ready():
	dmg = randi() % (dmgMax - dmgMin) + dmgMin
	mesh.get_surface_material(0).albedo_color = Color("509ce7")
	

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
				#rotate_y(PI/2)
	if !get_node_or_null(targetNodePath):
		queue_free()
		



func _on_Timer_timeout():
	queue_free()

func _on_Particle_area_entered(area):
	if area == target:
		target.get_parent().get_parent().hit(dmg, dmgType)
		timer.start(0.05)
		impacted = true
