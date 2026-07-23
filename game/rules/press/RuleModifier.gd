class_name PressRule extends Rule

func check(display_text: String, number: int, pressed: bool) -> bool:
	"""Should check if it should apply and if it should have been pressed"""
	if pressed and _press_condition_met(display_text, number):
		return true
	return (
		pressed and _press_condition_met(display_text, number)
	) or (
		not pressed and not _press_condition_met(display_text, number)
		)

func _press_condition_met(_display_text: String, _number: int) -> bool:
	"""Should check if the rule should be applied """
	return false
