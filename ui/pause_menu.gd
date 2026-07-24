class_name PauseMenu extends Control

signal resume_button_pressed()
signal restart_button_pressed()
signal options_button_pressedu()

func _on_resume_button_pressed():
	resume_button_pressed.emit()

func _on_restart_button_pressed():
	restart_button_pressed.emit()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_option_button_pressed():
	options_button_pressedu.emit()
