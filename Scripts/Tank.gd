extends PathFollow

export var SPEED = 5

var physicalResistance = 0
var electricResistance = 5
var hitdmg

onready var anim = get_node("KinematicBody/Tank/AnimationPlayer")
onready var area = get_node("KinematicBody/Area")
onready var timer = get_node("Timer")
onready var healthBar = get_node("Sprite3D")
onready var hud = get_tree().get_root().get_node("Level/HUD")
export var inCharRange = false

enum{
	electric, physical
	}

var rng = RandomNumberGenerator.new()
var max_health
var health = 200
var dead = false
var damage = 19
var reward = 8
var pos

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pos = rng.randf_range(-6, 4)
	max_health = health
	healthBar.update_bar(health, max_health)
	rotate_y(7*PI/12)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dead == false:
		set_offset(get_offset() + SPEED * delta)
		global_translate(Vector3(0, 0, pos))
	if health <= 0 and dead == false:
		dead = true
		timer.start(0.5)
		area.monitorable = false
		area.monitoring = false
		hud.add_money(reward)
		anim.play("Die")
	if get_unit_offset() == 1 and loop == false:
		hud.dmg(damage)
		queue_free()


func hit(dmg, type):
	hitdmg = dmg
	if type == physical:
		hitdmg -= physicalResistance
	if type == electric:
		hitdmg -= electricResistance
	
	if hitdmg < 1:
		hitdmg = 1
		
	health -= hitdmg
	healthBar.update_bar(health, max_health)
	



func _on_Timer_timeout():
	queue_free()
