extends Light2D

export(bool) var random_flicker = false
export(float) var flicker_period = 300.0
export(float) var flicker_rate = 100.0

const MAX_VALUE = 10000000
onready var noise = OpenSimplexNoise.new()

var value = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	value = randi() % MAX_VALUE
	noise.period = flicker_period

func _process(delta):
	if random_flicker:
		value += flicker_rate
		if value > MAX_VALUE:
			value = 0.0

		var alpha = ((noise.get_noise_1d(value) + 1) / 4.0) + 1
		energy = alpha

