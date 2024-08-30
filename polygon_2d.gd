#extends Polygon2D



extends Node2D

# Constants
var t_min = 0.0
var t_max = 2 * PI
var num_points = 100

# Polygon2D node reference
@export var polygon_node: Polygon2D

func _ready():
	# Create a list to store the points
	var points = []
	
	# Generate points along the path
	for i in range(num_points):
		var t = lerp(t_min, t_max, i / float(num_points - 1))
		var x = sin(t)
		var y = cos(t)
		points.append(Vector2(x * 100, y * 100))  # Scale for visibility
	
	# Set the points to the Polygon2D node
	polygon_node.polygon = points




## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
