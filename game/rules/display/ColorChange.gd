class_name ColorChange extends DisplayModifier

var proba: float

func _init(_proba: float) -> void:
	proba = _proba
	super._init("Sometimes number will be colored")

func apply(display_text: String, number: int) -> String:
	if randf() < proba:
		var c = ["blue", "red", "orange"].pick_random()
		return "[color=" + c + "]" + str(number) + "[/color]"
	return display_text

static func create_random_instance():
	return ColorChange.new(0.3)

static func is_unique() -> bool:
	return true
