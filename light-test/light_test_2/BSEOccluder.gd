extends Node2D

# @export var Occluder : Polygon2D
# TODO: add resource and build children from it


# Called when the node enters the scene tree for the first time.
func _ready():
	var poly = $Area2D/CollisionPolygon2D.polygon
	var lightOccluderPoly = OccluderPolygon2D.new()
	lightOccluderPoly.polygon = poly
	$LightOccluder2D.occluder = lightOccluderPoly
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
