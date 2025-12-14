@tool
extends Node2D

signal splash

var velocity: float = 0
var force: float = 0
var height: float = 0
var target_height: float = 0

var index: int = 0
var motion_factor: float = 0.02
var collided_with: Variant = null


@export var jointsVisible: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D


func _process(_delta: float) -> void:
	if jointsVisible:
		sprite.visible = true
	else:
		sprite.visible = false

func water_update(spring_constant: float, dampening: float) -> void:
	height = position.y
	
	var x: float = height - target_height
	var loss := -dampening * velocity
	
	force = -spring_constant * x + loss
	velocity += force
	
	position.y += velocity

func initialize(x_position: float, id: int) -> void:
	height = position.y
	target_height = position.y
	velocity = 0
	position.x = x_position
	index = id

func set_collision_width(value: float) -> void:
	var size: Variant = collision_shape.shape.get_size()
	
	var new_size: Vector2= Vector2(value/2, size.y)
	
	collision_shape.shape.set_size(new_size)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == Global.player:
		body.runtime_vars.is_floating = true
		print("collided")
	
	if body == collided_with:
		pass
	
	#if body.runtime_vars.is_falling:
		#motion_factor = 0.02
	#else:
		#var speed: Variant = body.velocity.y * 0.1
		#emit_signal("splash",index,speed)
	
	collided_with = body
	
	var speed: Variant = body.velocity.y * motion_factor
	emit_signal("splash",index,speed)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == Global.player:
		body.runtime_vars.is_floating = false
	
	if body == collided_with:
		pass
	
	collided_with = null
	
	var speed: Variant = body.velocity.y * motion_factor
	emit_signal("splash",index,speed)
