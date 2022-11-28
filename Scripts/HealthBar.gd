extends Sprite3D


onready var bar = get_node("Viewport/ProgressBar")

# Called when the node enters the scene tree for the first time.
func _ready():
	texture = $Viewport.get_texture()
	

func update_bar(health, full):
	bar.update_bar(health, full)
	
