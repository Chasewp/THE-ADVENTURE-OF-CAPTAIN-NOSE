class_name character extends CharacterBody2D

#@onready var actor : Node2D = get_parent()


#local variable
#var _is_bound : bool
#var _min : Vector2
#var _max : Vector2

#Local Varibale Jump
var _direction : float
var _jump_velocity : float

##Local Variables Smims
#var water_surface_height : float 
#var is_in_water : bool
#var is_below_surface : bool

#Exported Variables Locomotions
@export_category("Locomotion")
@export var _speed = 8 
@export var _acceleration : float = 16
@export var _deceleration : float = 32

#Exported Variable Jump
@export_category("Jump")
@export var _jump_height : float = 2.5
@export var _air_control : float = 0.5 
@export var _jump_dust : PackedScene

#Export Variable Spirates
@export_category("Sprite")
@export var _is_facing_left : bool
@export var _sprite_face_left :bool
@onready var sprite : Sprite2D = $Sprite2D

#Export Variable Swims
#@export_category("Smim")
#@export var _desity : float = -0.1
#@export var _drag : float = 0.5

 #Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var _sprite : Sprite2D = $Sprite2D
#@onready var _character_control = get_parent()

#Export Combat
#@export_category("Combat")
#@export_range(1,100) var  _max_health : int = 5
#@export_range(0,5) var _invicible_duration : float =0
#@export_range(0,5) var _attack_damage : int = 1

func _ready():
	_speed *= Global.ppt
	_acceleration *= Global.ppt
	_deceleration *= Global.ppt
	_jump_height *= Global.ppt
	_jump_velocity = sqrt(_jump_height * gravity * 2) * -1
	
#region Public Methods
func face_left():
	_sprite.flip_h = true
	
func face_right():
	_sprite.flip_h = false

func run(direction : float):
	_direction = direction
	
func jump():
	if is_on_floor():
		velocity.y = _jump_velocity
		_spawn_dust(_jump_dust)

func stop_jump():
	if velocity.y < 0:
		velocity.y = 0
#endregion		

func _physics_process(delta):
	if sign(_direction) == -1 :
		face_left()
	elif sign(_direction) == 1 :
		face_right()
		
	if is_on_floor():
		_ground_physics(delta)
	else :
		_air_physics(delta)
	move_and_slide()
	
func _ground_physics(delta : float):
	# decelerate to zero
	if _direction == 0:
		velocity.x = move_toward(velocity.x, 0, _deceleration * delta)
	
	# accelerate from not moving, or trying to move in same direction	
	elif  velocity.x == 0 || sign(_direction)== sign(velocity.x):
		velocity.x = move_toward(velocity.x, _direction * _speed, _acceleration  * delta)
	
	#decelerate if trying to move in oppsite direction
	else:
		velocity.x = move_toward(velocity.x, _direction * _speed, _deceleration  * delta)
	
	
func _air_physics (delta : float):
	velocity.y += gravity * delta
	if _direction:
		velocity.x = move_toward(velocity.x, _direction * _speed, _deceleration * _air_control * delta)

# Private func 
func _spawn_dust(dust : PackedScene):
	var _dust = dust.instantiate()
	_dust.position = position
	_dust.flip_h = _sprite.flip_h
	get_parent().add_child(_dust)
	

