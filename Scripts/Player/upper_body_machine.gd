extends Node

@export var startingState: State
var currentState: State

func init(parent: CharacterBody2D, gun_barrel: Marker2D, animation: AnimationPlayer) -> void:
	for child in get_children():
		child.parent = parent
		child.animation = animation
		child.gun_barrel = gun_barrel
	
	change_state(startingState)

func change_state(new_state: State) -> void:
	if currentState:
		currentState.exit()
	
	currentState = new_state
	currentState.enter()

func process_physics(delta: float) -> void:
	var new_state: State = currentState.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state: State = currentState.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state: State = currentState.process_frame(delta)
	if new_state:
		change_state(new_state)
