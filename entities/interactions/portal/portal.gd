@tool
extends Node2D

signal declare_interaction
signal undeclare_interaction

@export_group("Properties")
@export var texture: Texture
@export var animatedSprite: SpriteFrames
@export var animeName: StringName = "default"
@export var textureScale: float = 1.0
@export var collisionShape: Shape2D

@export_enum("Right", "Left") var direction: int = 0

var parent: Node
@export var visiblityNotifier: bool = true


#@onready var area: Area2D = $Area2D
@onready var spawn_position: Marker2D = $SpawnPosition

@onready var sprite: Sprite2D = $Sprite2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	if get_parent() != null:
		parent = get_parent()
	
	apply_properties()

func _process(_delta: float) -> void:
	if !direction:
		self.scale = -abs(self.scale)
	elif direction:
		self.scale = abs(self.scale)
	
	if Engine.is_editor_hint():
		apply_properties()
	
	
	self.declare_interaction.connect(func() -> void:
		Global.player.runtime_vars.obj_you_interacted_with = self)
	
	self.undeclare_interaction.connect(func() -> void:
		Global.player.runtime_vars.obj_you_interacted_with = null)

func apply_properties() -> void:
	if animatedSprite:
		texture.texture = null
		animated_sprite.sprite_frames = animatedSprite
		animated_sprite.scale.x = textureScale
		animated_sprite.scale.y = textureScale
		
		if !animatedSprite.is_playing():
			animated_sprite.play(animeName)
	
	elif texture:
		animated_sprite.stop()
		sprite.texture = texture
		sprite.scale.x = textureScale
		sprite.scale.y = textureScale
	
	
	if collisionShape:
		collision_shape.shape = collisionShape
	
	visible_on_screen_notifier.visible = visiblityNotifier

func interact() -> void:
	parent.connected_portal = self


#func _on_player_detector_body_entered(body: Node2D) -> void:
	#if body == parent.player:
		#body.runtime_vars.obj_you_interacted_with = self
#
#func _on_player_detector_body_exited(body: Node2D) -> void:
	#if body == parent.player:
		#body.runtime_vars.obj_you_interacted_with = null
