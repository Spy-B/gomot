extends NPCsState

@onready var dialogue_box: Control = $"../../UI/DialogueBox"
@onready var ez_dialogue: EzDialogue = $"../../UI/DialogueBox/EzDialogue"

func enter() -> void:
	print("[Enemy][State]: Talk")
	super()
	animation.speed_scale = 0.5
	
	
	Global.player.runtime_vars.is_in_dialogue = true
	Global.player.runtime_vars.npc_you_talk_to = parent
	
	(ez_dialogue as EzDialogue).start_dialogue(parent.dialogueJson, parent.state)

func process_input(_event: InputEvent) -> NPCsState:
	return null

func process_frame(_delta: float) -> NPCsState:
	if !Global.player.runtime_vars.is_in_dialogue:
		return parent.idleState
	
	return null

func process_physics(delta: float) -> NPCsState:
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	parent.move_and_slide()
	
	return null

func _on_ez_dialogue_dialogue_generated(response: DialogueResponse) -> void:
	dialogue_box.add_text(response.text)

func _on_ez_dialogue_end_of_dialogue_reached() -> void:
	if !dialogue_box.dialogue_text.text:
		Global.player.runtime_vars.is_in_dialogue = false
		Global.player.runtime_vars.start_dialogue = false

func exit() -> void:
	animation.speed_scale = 1.0
