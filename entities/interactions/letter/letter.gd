@tool
extends Node2D

signal declare_interaction
signal undeclare_interaction

@export_group("Properties")
@export_multiline var letterText: String
#@export var playerGroup: String = "Player"
@export var letterTexture: Texture
@export var animatedLetterSprite: SpriteFrames
@export var animeName: StringName = "default"
@export var letterTextureScale: float = 1.0
@export var collisionShape: Shape2D

@export var visiblityNotifier: bool = true


@onready var sprite: Sprite2D = $Sprite2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var ui: CanvasLayer = $UI
@onready var texture_rect: TextureRect = $UI/Control/TextureRect
@onready var label: Label = $UI/Control/Label
@onready var quit: Button = $UI/Control/Quit

@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D


func _ready() -> void:
	apply_properties()
	
	if OS.get_name() == "Android":
		quit.visible = true


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		apply_properties()
	
	
	self.declare_interaction.connect(func() -> void:
		Global.player.runtime_vars.obj_you_interacted_with = self)
	
	self.undeclare_interaction.connect(func() -> void:
		Global.player.runtime_vars.obj_you_interacted_with = null)


func apply_properties() -> void:
	if letterText:
		label.text = letterText
	
	if animatedLetterSprite:
		sprite.texture = null
		animated_sprite.sprite_frames = animatedLetterSprite
		animated_sprite.scale.x = letterTextureScale
		animated_sprite.scale.y = letterTextureScale
		
	elif letterTexture:
		sprite.texture = letterTexture
		sprite.scale.x = letterTextureScale
		sprite.scale.y = letterTextureScale
	
	if collisionShape:
		collision_shape.shape = collisionShape
	
	visible_on_screen_notifier.visible = visiblityNotifier

func interact() -> void:
	_on_quit_pressed()

func _on_quit_pressed() -> void:
	ui.visible = !ui.visible
	Global.player.ui.interact_key.visible = !Global.player.ui.interact_key.visible
	
	if OS.get_name() == "Android":
		Global.player.phone_ui.visible = !Global.player.phone_ui.visible
	
	#get_tree().paused = !get_tree().paused
