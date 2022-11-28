extends Spatial

export var force = 4.0
export var g = Vector3.DOWN * 9.8
# t was just to keep track of time
var t = 0
# speed is just to make things move faster
export var speed = 1

var time = 0
var velocity = Vector3()

# init_xy is the initial upward angle while init_xz is the angle pointing toward the target.
var init_xy = 0
var init_xz = 0

enum{
	electric, physical
	}

var direction = Vector3()
var target
var impacted = false
var dmg = 20
var dmgType = physical
var timing = false
var initDistance
var initXZ
var currentDistance
var targetXZ

onready var mesh = get_node("MeshInstance2")
onready var area = get_node("Area")

func ready():
	mesh.get_surface_material(0).albedo_color = Color("509ce7")
#	var startingPos = translation
	

func _physics_process(delta):
	if !impacted:
		velocity += g * delta * speed
	# This makes the arrow point in the direction of travel, like in real life.
		look_at(transform.origin + velocity.normalized(), Vector3.UP)
	# pretty much does the work for you. Although this might be different if you aren't
	# using a KinematicBody.
		translate(velocity*delta*speed)
	#if !impacted:
		#direction = target - global_translation
		#translation += direction.normalized() * delta * speed
		#if direction:
			#var look_at_direction = direction + global_translation
			#look_at(look_at_direction, Vector3.UP)

func _process(delta):
	currentDistance = Vector2(target.x, target.y) - Vector2(translation.x, translation.y)
	var dis = sqrt(pow(currentDistance.x, 2) - pow(currentDistance.y, 2)) / sqrt(pow(initDistance.x, 2) - pow(initDistance.y, 2))
	if dis < 0.5:
		target.y = 0.5
	
	if timing:
		time += delta
	print(global_translation.y)
	if translation.y < 1:
		impacted = true
		timing = true
	t += delta
	if time > 0.3:
		queue_free()
	
# force is the forward movement of the projectile
# I initialized the angles beforehand in a different scene so all I had to do was
# add the arrow to the tree for it to shoot.
func _ready():
	rotate_x(init_xy)
	rotate_y(init_xz)
	velocity += -transform.basis.z * force
