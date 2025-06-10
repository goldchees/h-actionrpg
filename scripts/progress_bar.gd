extends ProgressBar
#
#func _ready() -> void:
	#value = health

func _process(delta: float) -> void:
	value = Global.health
