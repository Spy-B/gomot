extends CharacterBody2D

var runtime_vars: Dictionary = {
	"movementWeight": 0.2,
	"health": 100,
	"player_detected": false,
	"cool_down": false,
	"damaged": false,
	"damage_value": 0,
	"waiting_time": 0.0,
	"player_pos": Vector2(0, 0),
}

var status_history: Array = []

@export_enum("Enemy", "Friendly") var NpcType: int = 0

@export_group("NPC States")
@export var idleState: NPCsState
@export var wanderingState: NPCsState
@export var chasingState: NPCsState
@export var cooldownState: NPCsState
@export var shootingState: NPCsState
@export var reloadingState: NPCsState
@export var talkingState: NPCsState
@export var damagingState: NPCsState
@export var deathState: NPCsState

#@export_group("Animations")
#@export var idleAnime: StringName

@export_category("NPC Abilities")

@export_group("Movement Ability")
@export var walkSpeed: int = 100
@export var runSpeed: int = 200
var dir: int = 1

@export_group("Shooting Ability")
@export var bulletScene: PackedScene
@export var ammoInMag: int = 9
@export var maxAmmo: int = 9
@export var extraAmmo: int = 999
@export_range(0, 1, 0.05) var fireRate: float = 0.5

##Dialogue System
@export_group("Others")
@export var dialogueJson: JSON
@onready var state: Dictionary = {}


@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var g_ray_cast: RayCast2D = $Sprite2D/RayCasts/GRayCast
@onready var w_ray_cast: RayCast2D = $Sprite2D/RayCasts/WRayCast
@onready var shoot_ray_cast: RayCast2D = $Sprite2D/RayCasts/ShootRayCast
@onready var player_detector: RayCast2D = $Sprite2D/RayCasts/PlayerDetector

@onready var gun_barrel: Marker2D = $Sprite2D/GunBarrel

@onready var npcs_state_machine: Node = $NPCsStateMachine

##Roaming game states timer
@onready var rgs_timer: Timer = $Timers/RGSTimer
@onready var shooting_timer: Timer = $Timers/ShootingTimer
#@onready var cooldown_period_timer: Timer = $Timers/CooldownPeriodTimer

@onready var health_bar: TextureProgressBar = $TextureProgressBar


func _ready() -> void:
	npcs_state_machine.init(self, sprite, animation_player, gun_barrel)
	
	match NpcType:
		0:
			self.add_to_group("Enemy")
			
			set_collision_layer_value(17, true)
			set_collision_layer_value(25, false)
			
			set_collision_mask_value(9, true)
			
			randomize()
			runtime_vars.waiting_time = randf_range(1, 3)
			
			rgs_timer.wait_time = runtime_vars.waiting_time
			rgs_timer.start()
			
			shoot_ray_cast.enabled = true
			player_detector.enabled = true
		
		1:
			self.add_to_group("Friendly")
			
			set_collision_layer_value(17, false)
			set_collision_layer_value(25, true)
			
			set_collision_mask_value(9, false)
			
			health_bar.visible = false
			
			g_ray_cast.enabled = false
			w_ray_cast.enabled = false
			shoot_ray_cast.enabled = false
			player_detector.enabled = false

func _unhandled_input(event: InputEvent) -> void:
	npcs_state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	npcs_state_machine.process_physics(delta)

func _process(delta: float) -> void:
	npcs_state_machine.process_frame(delta)
	
	if player_detector.get_collider() == Global.player:
		runtime_vars.player_detected = true
		runtime_vars.cool_down = false
