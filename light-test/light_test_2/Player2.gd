extends RigidBody2D

@export var aiming_speed = 1.4
@export var normal_speed = 2.8

var occluders_in_range = []

# Called when the node enters the scene tree for the first time.
func _ready():
	normal_speed = 2.8
	aiming_speed = 1.4

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
	queue_redraw()
	
func _checkRay():
	pass
	# Instead of a ray, we can use an area2d and cast a ray across the edges 
	# to detect what to draw, then draw them left-to-right so we get
	# an occlusion polygon

	# Next steps
	#   draw lines to each corner of the polygon
	#   set up proper resource to pass in and create both area2d and occluder
	#   Handle different types of area2d shapes for the future if nessessary

	# var collision = $OccluderDetector.get_overlapping_areas()
	# if collision:
	# 	var edges = collision[0].get_node("CollisionPolygon2D").polygon
	# 	drawLineToEdges(edges);

func extractVectors():
	var vectors = PackedVector2Array()
	for area in occluders_in_range:
		var poly = area.get_node("CollisionPolygon2D").polygon
		var area_pos = area.get_global_transform_with_canvas()
		vectors += convertVectorsToLocal(poly, area_pos)
	return vectors

func convertVectorsToLocal(poly, area_pos):
	var vectors = PackedVector2Array()
	for vector in poly:
		var moved_vector = (vector + area_pos.origin)
		vectors.push_back(moved_vector)
	return vectors

func _draw():
	for vector in extractVectors():
		# print(vector)
		# draw_line(Vector2(0, 0), Vector2(100, 100), Color(100, 100, 100, 50), 24)
		draw_line(Vector2(0, 0), to_local(vector), Color(100, 100, 100, 50))

# # func drawLineToEdges(vectorArray):

func _on_occluder_detector_area_entered(area):
	occluders_in_range.push_back(area)

func _on_occluder_detector_area_exited(area):
	occluders_in_range.erase(area)
