class_name GoldenRule extends PressRule

func _init() -> void:
	super._init("Press when the countdown reaches zero")

func _press_condition_met(display_text: String, number: int) -> bool:
	"""Should check if it should apply and if it should have been pressed"""
	return number == 0
