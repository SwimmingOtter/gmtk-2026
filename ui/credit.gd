class_name CreditMenu extends Control

signal escape_button_pressed()

func _on_escape_button_pressed():
	escape_button_pressed.emit()
