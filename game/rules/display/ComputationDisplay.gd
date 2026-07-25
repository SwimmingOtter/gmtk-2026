class_name ComputationDisplay extends DisplayModifier

var proba: float

func _init(_proba: float) -> void:
	proba = _proba
	super._init("Sometimes number will be displayed as sum")

func apply(display_text: String, number: int) -> String:
	if randf() < proba and number > 0:
		var rand_n: int = randi() % number
		return str(number - rand_n) + "+" + str(rand_n)
	return display_text

static func create_random_instance():
	return ComputationDisplay.new(0.1)

static func is_unique() -> bool:
	return true
