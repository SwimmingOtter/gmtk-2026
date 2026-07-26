class_name StartMenu extends Control

signal hidden_start_button_pressed

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("esc"):
		%Credit.visible = false
			
func _ready() -> void:
	%Credit.visible = false


func _on_credits_button_pressed() -> void:
	%Credit.visible=true


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_credit_escape_button_pressed() -> void:
	%Credit.visible = false


func _on_hidden_start_button_pressed() -> void:
	hidden_start_button_pressed.emit()
