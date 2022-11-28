extends Area


onready var character = get_parent().get_node("MainCharacter") 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	translation = character.translation

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
