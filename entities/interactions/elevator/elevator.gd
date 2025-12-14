@tool
extends Node2D

#var elevator_arrived: bool = true

@export_range(0.1, 5.0, 0.1, "or_greater") var speedScale: float = 1.0
@export_range(0.0, 1.0, 0.1) var MovementPath: float = 0.0

@export_group("Properties")
@export var texture: Texture
@export var textureScale: float = 1.0
@export var collisionShape: Shape2D
@export var rotatedCollision: bool = true

@export_group("Others")
@export var activation_key: StaticBody2D
#@export var visiblityNotifier: bool = true


@onready var path_follow: PathFollow2D = $PathFollow2D
@onready var animatable_body: AnimatableBody2D = $AnimatableBody2D

@onready var elevator_sprite: Sprite2D = $AnimatableBody2D/Sprite2D
@onready var collision_shape: CollisionShape2D = $AnimatableBody2D/CollisionShape2D

@onready var activation_area_collision: CollisionShape2D = $AnimatableBody2D/ElevatorActivationKey/CollisionShape2D


func _ready() -> void:
	apply_properties()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		apply_properties()

		if self.curve != null:
			path_follow.progress_ratio = MovementPath
	
	else:
		if activation_key:
			activation_key.declare_interaction.connect(func() -> void:
				Global.player.runtime_vars.obj_you_interacted_with = self)
			
			activation_key.undeclare_interaction.connect(func() -> void:
				Global.player.runtime_vars.obj_you_interacted_with = null)
		else:
			printerr("Missing Activation Key -> [AIK]")


func apply_properties() -> void:
	if texture:
		elevator_sprite.texture = texture
	
	
		elevator_sprite.scale.x = textureScale
		elevator_sprite.scale.y = textureScale
	
	if collisionShape:
		collision_shape.shape = collisionShape
		if rotatedCollision:
			collision_shape.rotation_degrees = 90.0
		else:
			collision_shape.rotation_degrees = 0.0
	
	collision_shape.position.y = (elevator_sprite.texture.get_height() * elevator_sprite.scale.y) / 2

func interact() -> void:
	activation_key.is_interacting = true
	
	var tween: Tween
	activation_area_collision.set_deferred("set_disabled", true)
	
	if self.curve != null:
		if path_follow.progress_ratio == 0.0:
			tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
			tween.tween_property(path_follow, "progress_ratio", 1.0, 1.0 / speedScale)
		
		if path_follow.progress_ratio == 1.0:
			tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
			tween.tween_property(path_follow, "progress_ratio", 0.0, 1.0 / speedScale)


func _on_elevator_activation_key_body_entered(body: Node2D) -> void:
	if body == Global.player:
		interact()


func _on_elevator_activation_key_body_exited(body: Node2D) -> void:
	if body == Global.player:
		activation_area_collision.set_deferred("set_disabled", false)
