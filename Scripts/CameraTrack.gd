extends KinematicBody

var velocity = Vector3(0,0,0)
const SPEED = 70
var speed

onready var cam = get_node("Camera")

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	speed = SPEED * cam.fov / 70
	rotation.y = rotation.y + delta
	if Input.is_action_pressed("ui_right") and Input.is_action_pressed("ui_left"):
		velocity.x = lerp(velocity.x, 0, 0.1)
	elif Input.is_action_pressed("ui_right"):
		velocity.x = lerp(velocity.x, speed, 0.1)
	elif Input.is_action_pressed("ui_left"):
		velocity.x = lerp(velocity.x, -speed, 0.1)
	else:
		velocity.x = lerp(velocity.x, 0, 0.1)
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_down"):
		velocity.z = lerp(velocity.z, 0, 0.1)
	elif Input.is_action_pressed("ui_up"):
		velocity.z = lerp(velocity.z, -speed, 0.1)
	elif Input.is_action_pressed("ui_down"):
		velocity.z = lerp(velocity.z, speed, 0.1)
	else:
		velocity.z = lerp(velocity.z, 0, 0.1)
	var _redundant = move_and_slide(velocity)
