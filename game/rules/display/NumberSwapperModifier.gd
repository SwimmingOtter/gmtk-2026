class_name NumberSwapperModifier extends DisplayModifier

var target_number: int
var swap_text: String

func _init(_number: int, _swap_text: String) -> void:
	target_number = _number
	swap_text = _swap_text
	super._init("Swap %s by %s" % [str(target_number), swap_text])

func apply(display_text: String, number: int) -> String:
	if number == target_number:
		return swap_text
	return display_text

static func create_random_instance() -> NumberSwapperModifier:
	var a = 0
	var b = 0
	while a == b:
		a = randi() % (10 - 1) + 1
		b = randi() % 10
	
	return NumberSwapperModifier.new(a, str(b))
