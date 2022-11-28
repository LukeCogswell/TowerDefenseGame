extends PathFollow

var speed

enum{
	electric, physical
	}

var dead = true
var impacted = false
var dmg = 15
var dmgType = physical
var exploded = false
var targets = []
var detected = []

onready var bombPath = get_parent() 
onready var projectileArea = get_node("Bomb/Area")
onready var explosionArea = get_node("Bomb/MeshInstance")
onready var timer = get_node("Timer")

func _process(delta):
	if !impacted:
		if self.unit_offset < 0.2:
			speed = 1.5
		elif self.unit_offset < 0.5:
			if speed > 1:
				speed -= 0.1
		elif self.unit_offset < 0.7:
			if speed < 1.5:
				speed += 0.1
		
		self.unit_offset += delta * speed
	if self.unit_offset > 0.99:
		impacted = true
		if !exploded:
			explode()

func explode():
	exploded = true
	check_for_enemies()
	if targets:
		for k in targets.size():
			targets[k].hit(dmg, dmgType)
	self.get_child(0).get_child(0).visible = false
	explosionArea.visible = true
	timer.start(0.1)

func check_for_enemies():
	detected = projectileArea.get_overlapping_areas()
	var i = 0
	targets = []
	while i < detected.size():
		if detected[i].get_parent().get_parent().get_class() == "PathFollow" and detected[i].get_parent().get_parent().dead == false:
			targets.append(detected[i].get_parent().get_parent())
			i += 1
			continue
		else:
			i += 1
			continue
	if targets:
		return true
	return false


func _on_Timer_timeout():
	queue_free()
