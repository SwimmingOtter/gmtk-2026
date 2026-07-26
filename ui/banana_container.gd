extends GridContainer

@export var banana_scene: PackedScene

func _ready() -> void:
	EventBus.game_started.connect(_display_bananas)
	EventBus.button_pressed_error.connect(_remove_banana)
	EventBus.round_won.connect(_add_bananas)
	_remove_bananas()

func _create_one_banana():
	var sc = banana_scene.instantiate()
	add_child(sc)
	
func _display_bananas():
	_remove_bananas()
	for i in range(Constants.BASE_RETRY_COUNT):
		_create_one_banana()
		
func _remove_bananas():
	for child in get_children():
		child.free()
		
func _remove_banana():
	for i in range(Constants.RETRY_LOST_ON_ERROR):
		if get_child_count():
			var child = get_child(-1)
			if child:
				child.free()
		
func _add_bananas():
	for i in range(Constants.RETRY_WON_ON_SUCCES):
		_create_one_banana()
