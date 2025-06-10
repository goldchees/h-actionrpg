extends Control

signal restart

func _on_restart_btn_pressed() -> void:
	print('restart')
	restart.emit()
	
