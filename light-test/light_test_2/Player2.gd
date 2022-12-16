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
	
# func convertPolyToShadow(poly, position):
# 	var moved_poly_vectors = PackedVector2Array()
# 	var shadow_vectors = PackedVector2Array()
# 	for vector in poly:
# 		var start_vector = to_local(vector + position.origin)
# 		var end_vector = start_vector.normalized() * 300
# 		moved_poly_vectors.push_back(start_vector)
# 		shadow_vectors.push_back(end_vector)
# 		# moved_vectors.push_back(to_local(vector + position.origin))

# 	var finalVectors = PackedVector2Array()
# 	finalVectors.push_back(moved_poly_vectors[0])
# 	finalVectors += moved_poly_vectors
# 	finalVectors += shadow_vectors
# 	return finalVectors


# const FLOAT_EPSILON = 0.001

# static func compare_floats(a, b, epsilon = FLOAT_EPSILON):
# 	return abs(a - b) <= epsilon

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

func getEndVectorsForPoly(poly, position):
	var endVectors = PackedVector2Array()
	for vector in poly:
		var start_vector = to_local(vector + position.origin)
		endVectors.push_back(start_vector.normalized() * 3000)
	return endVectors


func convertPolyToShadowPolys(poly, position):
	var endVectors = getEndVectorsForPoly(poly, position)
	var shadowPolys = []

	for vector in poly:
		var shadow = PackedVector2Array()
		shadow.push_back(to_local(vector + position.origin))
		shadow += endVectors
		shadowPolys.push_back(shadow)

		# moved_poly_vectors.push_back(start_vector)
		# shadow_vectors.push_back(end_vector)
	
	var mainPoly = PackedVector2Array()
	for vector in poly:
		mainPoly.push_back(to_local(vector + position.origin))

	shadowPolys.push_back(mainPoly)
	return shadowPolys

func _draw():
	for area in occluders_in_range:
		var poly = area.get_node("CollisionPolygon2D").polygon
		var area_pos = area.get_global_transform_with_canvas()
		# var shadowPolygon = convertPolyToShadow(poly, area_pos)
		# print(shadowPolygon)
		# draw_colored_polygon(shadowPolygon, Color(100, 100, 100, 50))

		for vector in getEndVectorsForPoly(poly, area_pos):
			draw_line(Vector2(0, 0), vector, Color(0, 0, 100, 50))

		for shadowPoly in convertPolyToShadowPolys(poly, area_pos):
			draw_colored_polygon(shadowPoly, Color(0, 0, 0, 50))
			# draw_polyline(shadowPoly, Color(0, 0, 0, 1), 10)

		


	# var vectors = extractVectors()
	# draw_colored_polygon(vectors, Color(100, 100, 100, 50))
	# # get points to draw, connect them, draw polygon
	for vector in extractVectors(): # draw lines to verticies
		draw_line(Vector2(0, 0), to_local(vector), Color(100, 100, 100, 50))
		# draw_line(Vector2(0, 0), to_local(vector).normalized() * 10000, Color(100, 100, 100, 50)) # Draws line to and across verticie

# # func drawLineToEdges(vectorArray):

func _on_occluder_detector_area_entered(area):
	occluders_in_range.push_back(area)

func _on_occluder_detector_area_exited(area):
	occluders_in_range.erase(area)
