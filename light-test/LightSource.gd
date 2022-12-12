extends PointLight2D

@export var random_flicker: bool = false
@export var flicker_period: float = 300.0
@export var flicker_rate: float = 100.0

const MAX_VALUE = 10000000
#@onready var noise = OpenSimplexNoise.new()

var value = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# randomize()
#	value = randi() % MAX_VALUE
#	noise.period = flicker_period

func _process(delta):
	pass
#	if random_flicker:
#		value += flicker_rate
#		if value > MAX_VALUE:
#			value = 0.0
#		pass
#		var alpha = ((noise.get_noise_1d(value) + 1) / 4.0) + 1
#		energy = alpha

