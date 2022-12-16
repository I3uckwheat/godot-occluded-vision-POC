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
	
func _physics_process(_delta):
	queue_redraw()


func createOffsetPoly(poly, offset):
	var offsetVerticies = PackedVector2Array()
	for vertex in poly:
		offsetVerticies.push_back(to_local(vertex + offset))

	return offsetVerticies



const FLOAT_EPSILON = 0.01

func compare_vectors(vector_a, vector_b, epsilon = FLOAT_EPSILON):
	return compare_floats(vector_a.x, vector_b.x, epsilon) && compare_floats(vector_a.y, vector_b.y, epsilon)

func compare_floats(a, b, epsilon = FLOAT_EPSILON):
	return abs(a - b) <= epsilon

# Convert to handle multiple polygons
# maybe pass in the occluder here, loop elsewhere
func getOccluderHits():
	var space_state = get_world_2d().direct_space_state

	var hits = PackedVector2Array()
	for occluder in occluders_in_range:
		var poly = occluder.get_node("CollisionPolygon2D").polygon
		var poly_pos = occluder.get_node("CollisionPolygon2D").get_global_transform() 
		# draw_colored_polygon(createOffsetPoly(poly, poly_pos.origin), Color(0, 0, 0, 50)) # draw shadow polygons

		for vertex in createOffsetPoly(poly, poly_pos.origin):
			var query = PhysicsRayQueryParameters2D.create(global_position, to_global(vertex))
			query.collide_with_areas = true
			query.collide_with_bodies = false
			query.exclude = [self]

			var result = space_state.intersect_ray(query)

			if result.size() > 1:
				draw_line(to_local(global_position), to_local(result["position"]), Color(0, 0, 100, 50)) # draw hit lines
				print(to_global(vertex), result["position"]) # draw comparasons
				if compare_vectors(to_global(vertex), result["position"], 3):
					hits.push_back(vertex)

	return hits

# TODO: check left and right to find edges
func getShadowPolygons():
	var hits = getOccluderHits()
	for vector in hits:
		pass
		# HERE IS WHERE YOU"RE WORKING
		# get points past player to a range that move across the hits
		# connect points into a polygon
		# render

		# draw_line(Vector2(0, 0), vector, Color(0, 100, 0, 50))

func _draw():
	for area in occluders_in_range:
		# var hits = getOccluderHits()
		# for vector in hits:
		# 	draw_line(Vector2(0, 0), vector, Color(0, 100, 0, 50))

		

		# var transformedPoly = getTransformedPoints(poly, area_pos)
		# draw_colored_polygon(transformedPoly, Color(0, 0, 0, 50))
		pass
		# var shadowPolygon = convertPolyToShadow(poly, area_pos)
		# print(shadowPolygon)
		# draw_colored_polygon(shadowPolygon, Color(100, 100, 100, 50))

		# for vector in getEndVectorsForPoly(poly, area_pos):
		# 	draw_line(Vector2(0, 0), vector, Color(0, 0, 100, 50))

		# for shadowPoly in convertPolyToShadowPolys(poly, area_pos):
		# 	draw_colored_polygon(shadowPoly, Color(0, 0, 0, 50))
			# draw_polyline(shadowPoly, Color(0, 0, 0, 1), 10)

		


	# var vectors = extractVectors()
	# draw_colored_polygon(vectors, Color(100, 100, 100, 50))
	# # get points to draw, connect them, draw polygon
	# for vector in extractVectors(): # draw lines to verticies
	# 	draw_line(Vector2(0, 0), to_local(vector), Color(100, 100, 100, 50))
		# draw_line(Vector2(0, 0), to_local(vector).normalized() * 10000, Color(100, 100, 100, 50)) # Draws line to and across verticie

# # func drawLineToEdges(vectorArray):

func _on_occluder_detector_area_entered(area):
	if area.is_in_group("shadow"):
		occluders_in_range.push_back(area)

func _on_occluder_detector_area_exited(area):
	occluders_in_range.erase(area)
