class_name NPCsState
extends Node

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var animationName: StringName


var parent: CharacterBody2D
var sprite: Sprite2D
var animation: AnimationPlayer
var gun_barrel: Marker2D


func enter() -> void:
	animation.play(animationName)

func exit() -> void:
	pass

func process_physics(_delta: float) -> NPCsState:
	return null

func process_input(_event: InputEvent) -> NPCsState:
	return null

func process_frame(_delta: float) -> NPCsState:
	return null
