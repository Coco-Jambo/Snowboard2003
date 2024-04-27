extends Panel

@onready var label_2 = $Label2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label_2.text = str(Global.score)
