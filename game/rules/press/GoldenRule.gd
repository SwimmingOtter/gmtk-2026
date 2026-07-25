class_name GoldenRule extends PressRule

func _init() -> void:
	super._init("Press when the countdown reached 0")

func _press_condition_met(_display_text: String, number: int) -> bool:
	"""Should check if it should apply and if it should have been pressed"""
	return number == 0
