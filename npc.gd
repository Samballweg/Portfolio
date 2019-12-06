extends "res://charactor.gd"


enum States {IDLE, WALK}
enum Events {STOP, MOVE}

const STOP_THRESHOLD = 1e-2
const PATROL_DISTANCE = 200
const SPEED = 300

var _direction = Vector2(-1,0)
var _target_postion = Vector2()

func _init():
	_transitions = {
		[States.IDLE, Events.MOVE]: States.WALK,
		[States.WALK, Events.STOP]: States.IDLE
	}


func _ready():
	$Timer.connect("timeout", self, "change_state", [Events.MOVE])
	$CollisionShape2D.disabled = true
	$Timer.wait_time = 0.5 + 1.5 * randf()
	$Timer.start()


func enter_state():
	match state:
		States.IDLE:
			$Timer.start()
			$Pivot/Body.play("BASE")
		
		States.WALK:
			_direction.x *= -1
			_target_postion = postion + PATROL_DISTANCE + _direction
			$Pivot/Body.play("move")