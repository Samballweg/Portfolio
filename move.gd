extends 'state.gd'

func enter(host):
	host.get_node('AnimationPlayer').play("walk")



func handle_input(host, event):
	if event.is_action_pressed('attack'):
		return ''
	elif event.is_action_pressed('jump'):
		return 'jump'


func update(host, delta):
	var input_direction = get_input_direction()
	if not input_direction:
		return 'idle'


func get_input_direction():
	var input_direction = Vector2()
	input_direction.x = int(Input.is_action_pressed('move_right')) - int(Input.is_action_pressed('move_left')) 
	input_direction.y = int(Input.is_action_pressed('move_down')) - int(Input.is_action_pressed('move_up')) 
	return input_direction