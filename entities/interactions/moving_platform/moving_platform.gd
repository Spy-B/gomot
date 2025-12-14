@tool
extends Path2D

@export var loop: bool = true
var speed: float = 1.0
@export var speedScale: float = 1.0

@export_group("Properties")
@export var texture: Texture
@export var animatedTexture: SpriteFrames
@export var animeName: StringName = "default"

@export var textureScale: float = 1.0

@export var collisionShape: Shape2D

@export_group("Others")
@export var player: CharacterBody2D
@export var damage: int = 25

@export var visiblityNotifier: bool = true


@onready var path_follow: PathFollow2D = $PathFollow2D
@onready var sprite: Sprite2D = $Platform/PlatformSprite
@onready var animated_sprite: AnimatedSprite2D = $Platform/AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $Platform/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = $Platform/VisibleOnScreenNotifier2D


func _ready() -> void:
	if loop && curve != null:
		animation_player.play("Moving")
		set_physics_process(false)
	
	apply_properties()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		apply_properties()

func _physics_process(_delta: float) -> void:
	path_follow.progress += speed


func apply_properties() -> void:
	if animatedTexture:
		animated_sprite.sprite_frames = animatedTexture
	
		if !animated_sprite.is_playing():
			animated_sprite.play(animeName)
	
	elif sprite:
		sprite.texture = texture
	
	
		sprite.scale.x = textureScale
		sprite.scale.y = textureScale
		animated_sprite.scale.x = textureScale
		animated_sprite.scale.y = textureScale
	
	if collisionShape:
		collision_shape.shape = collisionShape
	
	visible_on_screen_notifier.visible = visiblityNotifier
	
	animation_player.speed_scale = speedScale
