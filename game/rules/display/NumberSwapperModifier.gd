class_name NumberSwapperModifier extends DisplayModifier

var description: String = "Swap the numbers 6 and 9"
var target_number: int
var swap_text: String

func _init(_number: int, _swap_text: String) -> void:
	target_number = _number
	swap_text = _swap_text

func apply(display_text: String, number: int) -> String:
	"""Should check if it should apply and if it should have been pressed"""
	if number == target_number:
		return swap_text
	return display_text
