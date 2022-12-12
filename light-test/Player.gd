extends RigidBody2D

@export var aiming_speed = 1.4
@export var normal_speed = 2.8

# Called when the node enters the scene tree for the first time.
func _ready():
#	$PlayerFOV.visible = true
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var move_impulse = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		move_impulse.x = 1
	if Input.is_action_pressed("move_left"):
		move_impulse.x = -1
	if Input.is_action_pressed("move_down"):
		move_impulse.y = 1
	if Input.is_action_pressed("move_up"):
		move_impulse.y = -1
	
	if Input.is_action_pressed("ready_weapon"):
		#	Just create a child to rotate instead of this RigidBody2d
		$Body.look_at(get_global_mouse_position())
	else:
		$Body.rotation = self.linear_velocity.angle()

	if Input.is_action_just_pressed("ready_weapon"):
		$Body/PlayerBody/Weapon.visible = true
	elif Input.is_action_just_released("ready_weapon"):
		$Body/PlayerBody/Weapon.visible = false
	
	var speed = normal_speed
	if Input.is_action_pressed("ready_weapon"):
		speed = aiming_speed
	
	apply_central_impulse(move_impulse.normalized() * speed)
