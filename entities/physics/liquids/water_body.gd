extends Node2D

@export var stiffness: float = 0.07
@export var dampening: float = 0.04
@export var spread: float = 0.2

var springs: Array = []
var passes: int = 12

@export var distance_between_springs: int = 24
@export var spring_number: int = 8

var water_lenght: float = distance_between_springs * spring_number

@export_range(100, 10000, 100, "or_greater") var depth: int = 1000
var target_height: float = global_position.y

var bottom: float = target_height + depth

@export_range(0.0, 5.0, 0.1, "or_greater") var border_thickness: float = 1.0


@onready var water_polygon: Polygon2D = $WaterPolygon
@onready var water_border: SmoothPath = $WaterBorder
@onready var water_body_area: Area2D = $WaterBodyArea
@onready var collision_shape: CollisionShape2D = $WaterBodyArea/CollisionShape2D

@onready var water_spring: PackedScene = preload("uid://dvhtyx5jfkwlv")
@onready var splash_particle: PackedScene = preload("uid://h5ydh27dqpuq")


func _ready() -> void:
	water_border.width = border_thickness
	
	spread = spread / 1000
	
	for i in range(spring_number):
		var x_position := distance_between_springs * i
		var w := water_spring.instantiate()
		add_child(w)
		springs.append(w)
		w.initialize(x_position, i)
		w.set_collision_width(distance_between_springs)
		w.connect("splash", Callable(self, "splash"))
	
	var total_lenght := distance_between_springs * (spring_number - 1)
	
	var rectangle := RectangleShape2D.new().duplicate()
	
	@warning_ignore("integer_division")
	var w_position: Vector2 = Vector2(total_lenght / 2, depth / 2)
	@warning_ignore("integer_division")
	var rect_extents: Vector2 = Vector2(total_lenght / 2, depth / 2)
	
	water_body_area.position = w_position
	rectangle.set_size(rect_extents)
	collision_shape.set_shape(rectangle)

func _physics_process(_delta: float) -> void:
	@warning_ignore("untyped_declaration")
	for i in springs:
		i.water_update(stiffness,dampening)
	
	
	var left_deltas: Array = []
	var right_deltas: Array = []
	
	for i in range (springs.size()):
		left_deltas.append(0)
		right_deltas.append(0)
	
	for j in range(passes):
		for i in range(springs.size()):
			if i > 0:
				left_deltas[i] = spread * (springs[i].height - springs[i-1].height)
				springs[i-1].velocity += left_deltas[i]
			if i < springs.size()-1:
				right_deltas[i] = spread * (springs[i].height - springs[i+1].height)
				springs[i+1].velocity += right_deltas[i]
	new_border()
	draw_water_body()

func draw_water_body() -> void:
	var curve := water_border.curve
	
	var points := Array(curve.get_baked_points())
	
	var water_polygon_points := points
	
	var first_index := 0
	var last_index := water_polygon_points.size() - 1
	
	water_polygon_points.append(Vector2(water_polygon_points[last_index].x, bottom))
	water_polygon_points.append(Vector2(water_polygon_points[first_index].x, bottom))
	
	water_polygon_points = PackedVector2Array(water_polygon_points)
	
	water_polygon.set_polygon(water_polygon_points)
	water_polygon.set_uv(water_polygon_points)

func new_border() -> void:
	var curve := Curve2D.new().duplicate()
	
	var surface_points: Array = []
	for i in range(springs.size()):
		surface_points.append(springs[i].position)
	
	for i in range(surface_points.size()):
		curve.add_point(surface_points[i])
	
	water_border.curve = curve
	water_border.smooth(true)
	water_border.queue_redraw()

func splash(index: int, speed: float) -> void:
	if index >= 0 and index < springs.size():
		springs[index].velocity += speed

func _on_Water_Body_Area_body_entered(body: Node2D) -> void:
	body.in_water()
	
	var s := splash_particle.instantiate()
	
	get_tree().current_scene.add_child(s)
	
	s.global_position = body.global_position
