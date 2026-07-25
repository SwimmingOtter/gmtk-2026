class_name CountdownManager extends Node


static func generate_countdown(round_id: int) -> int:
	if round_id == 0: # First Round
		return 5
	elif round_id < 2:
		return _generate_randomized_countdown(round_id, 0)
	elif round_id < 10:
		return _generate_randomized_countdown(round_id, 1)
	elif round_id < 15:
		return _generate_randomized_countdown(round_id, 2)
	return _generate_randomized_countdown(round_id + 1, 2)


static func _generate_randomized_countdown(max_nb: int, random_delta: int) -> int:
	var delta: int  = 0
	if random_delta:
		delta = randi() % (random_delta * 2) - random_delta # random int between [-random_delta, random_delta]
	
	if Constants.DEBUG_MODE:
		print("countdown: max_nb " + str(max_nb) + ", random_delta " + str(random_delta) + ", delta " + str(delta))
	return max_nb + delta
