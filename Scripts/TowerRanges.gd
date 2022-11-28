extends Spatial

var buildPad

# Called when the node enters the scene tree for the first time.
func _ready():
	translation = buildPad.global_translation
