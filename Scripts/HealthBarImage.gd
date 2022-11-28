extends TextureProgress


var bar_red = preload("res://Assets/HealthBar/HealthBar3.png")
var bar_green = preload("res://Assets/HealthBar/HealthBar.png")
var bar_yellow = preload("res://Assets/HealthBar/HealthBar2.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func update_bar(amount, full):
	max_value = full
	texture_progress = bar_green
	if amount < (0.75 * full):
		texture_progress = bar_yellow
	if amount < (0.3 * full):
		texture_progress = bar_red
	value = amount
