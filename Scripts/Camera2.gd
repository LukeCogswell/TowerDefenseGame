extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var distance = 0.0
export var height = 80.0
var zoom_max = 1.1
var zoom_min = 0.6
var zoom_speed = 0.1
onready var cam = self
var des_zoom = 1
var zoom = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	set_as_toplevel(true)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	zoom = lerp(zoom, des_zoom, 0.2)
	cam.set_perspective(70*zoom, 0.05, 1000)

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_WHEEL_UP:
			if des_zoom > zoom_min:
				des_zoom -= zoom_speed
		if event.button_index == BUTTON_WHEEL_DOWN:
			if des_zoom < zoom_max:
				des_zoom += zoom_speed

func _physics_process(_delta):
	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin
	var up = Vector3(0,1,-1)
	
	var offset = pos - target
	
	offset = offset.normalized()*distance
	offset.y = height
	
	pos = target + offset
	pos.x = target.x
	
	translation = pos
	look_at(target, up)
