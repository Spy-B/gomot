extends State

func enter() -> void:
	print("[State] -> Interacting")
	super()
	
	parent.runtime_vars.obj_you_interacted_with.interact()

func exit() -> void:
	parent.runtime_vars.start_interact = false


func process_frame(_delta: float) -> State:
	parent.runtime_vars.start_interact = true
	parent.ui.interact_key.visible = false
	
	return parent.idleState
