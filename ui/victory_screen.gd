class_name VictoryScreen extends Control

signal replay_button_pressed()

func display_hype_text(text: String):
	%Label2.text = text


func _on_replay_button_pressed() -> void:
	replay_button_pressed.emit()
