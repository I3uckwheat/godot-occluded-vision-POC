extends RigidBody2D

export var aiming_speed = 1.4
export var normal_speed = 2.8

func enable_shadow(val):
#	$RedLight.shadow_enabled = val
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	$PlayerFOV.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("move_right"):
		velocity.x = 1
	if Input.is_action_pressed("move_left"):
		velocity.x = -1
	if Input.is_action_pressed("move_down"):
		velocity.y = 1
	if Input.is_action_pressed("move_up"):
		velocity.y = -1
	
	if Input.is_action_pressed("ready_weapon"):
		$Body.look_at(get_global_mouse_position())
#		Just create a child to rotate instead of this RigidBody2d

	if Input.is_action_just_pressed("ready_weapon"):
		$Body/PlayerBody/Weapon.visible = true
	elif Input.is_action_just_released("ready_weapon"):
		$Body/PlayerBody/Weapon.visible = false
	
	var speed = normal_speed
	if Input.is_action_pressed("ready_weapon"):
		speed = aiming_speed
	
	apply_central_impulse(velocity.normalized() * speed)

# Use linear_velocity for facing while walking normally (not aiming)
