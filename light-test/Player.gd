extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var aiming_speed = 180
export var normal_speed = 350
#var screen_size
#@export var set_shadows: bool = false : set = enable_shadow

func enable_shadow(val):
#	$RedLight.shadow_enabled = val
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		if Input.is_action_pressed("ready_weapon"):
			velocity = velocity.normalized() * aiming_speed
		else:
			velocity = velocity.normalized() * normal_speed
	
	if Input.is_action_pressed("ready_weapon"):
		look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("ready_weapon"):
		get_node("Weapon").visible = true
	elif Input.is_action_just_released("ready_weapon"):
		get_node("Weapon").visible = false
	
	move_and_slide(velocity)
	
	
	
