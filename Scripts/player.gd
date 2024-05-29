class_name  player extends Node

@export var actor : character
@export var in_control:= true
@onready var _character = get_parent()

func _input(event : InputEvent):
	if in_control:
		if event.is_action_pressed("jump"):
			_character.jump()
		if event.is_action_released("jump"):
			_character.stop_jump()
		if event.is_action_pressed("Control_char 2"):
			_character.remove_child(self)
			_character.add_child($MrCraby)
			in_control = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float):
	_character.run(Input.get_axis("run_left","run_right"))
	
