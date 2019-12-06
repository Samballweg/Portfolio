extends 'res://charactor.gd'

signal speed_change(speed, max_speed)


const MoveGroundStrategy = preload("res://helpers/move-ground-strategy.gd")

enum States{
IDLE,
WALK,
RUN,
BUMP,
JUMP
FALL,
RESPAWN
}

enum Events {
	INVALID=-1,
	STOP,
	IDLE,
	WALK,
	RUN,
	BUMP,
	JUST,
	FALL,
	RESPAWN
}


const SPEED = {
	States.WALK: 450,
	States.RUN: 700,
}

const MOVE_STRATEGY = {
	States.WALK: MoveGroundStrategy,
	States.RUN: MoveGroundStrategy,
}
var _speed = 0 setget _set_speed
var _max_speed = 0
var _velocity = Vector2()
var _collision_normal = Vector2()
var _last_input_direction = Vector2()


func _init() -> void:
	_transitions = {
		[States.IDLE, Events.WALK]: States.WALK,
		[States.IDLE, Events.RUN]: States.RUN,
		[States.WALK, Events.STOP]: States.IDLE,
		[States.RUN, Events.STOP]: States.IDLE,
		[States.RUN, Events.WALK]: States.WALK,
	}


func _ready() -> void:
	$DirectionVisualizer.setup(self)

static func get_raw_input():
	return {
		direction = utils.get_input_direction(),
		is_running = Input.is_action_just_pressed("run")
	}

func _physics_process(delta):
	var input = get_raw_input()
	var event = decode_raw_input(input)
	change_state(event)
	
	match state:
		States.WALK, States.RUN:
			var params = MOVE_STRATEGY[state].go(input.direction, _speed, _velocity)
			self._speed = params.speed
			_velocity = params.velocity
			move_and_slide(_velocity)

func enter_state():
	match state:
		States.IDLE:
			$Pivot/Body.play("BASE")
			_velocity = Vector2()
			_max_speed = SPEED[States.WALK]
			self._speed = 0
		
		States.WALK, States.RUN:
			_max_speed = SPEED[state]
			self._speed = _max_speed
			$Pivot/Body.play("move")

static func decode_raw_input(input):
	var event = Events.INVALID
	
	if input.direction == Vector2():
		 event = Events.STOP
	elif input.is_running:
		event = Events.RUN
	else:
		event = Events.WALK
	
	return event

func _set_speed(new_speed):
	if _speed == new_speed:
		return
	_speed = new_speed
	emit_signal("speed_change", _speed, SPEED[States.RUN])