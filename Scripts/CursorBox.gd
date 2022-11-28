extends Area

var cursorPos
onready var mesh = get_node("MeshInstance")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func process(_delta):
	cursorPos = ScreenPointToRay()
	global_translation = cursorPos
	mesh.global_translation = global_translation

func ScreenPointToRay():
	var spaceState = get_world().direct_space_state
	
	var camera = get_tree().root.get_camera()
	var mousePos = get_viewport().get_mouse_position()
	var rayOrigin = camera.project_ray_origin(mousePos)
	var rayEnd  = rayOrigin + camera.project_ray_normal(mousePos) * 2000
	var rayArray = spaceState.intersect_ray(rayOrigin, rayEnd)
	if rayArray.has("position"):
		return rayArray["position"]
	return Vector3()
