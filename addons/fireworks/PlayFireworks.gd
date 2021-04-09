extends Node2D


export var firework_effects_path = "res://addons/fireworks/fireworks/"
export var end_wait_time = 3.0

onready var screen_width = get_viewport().size.x
onready var screen_height = get_viewport().size.y

signal InstructionDone
signal FireWorkDone


func get_help() -> String:
	return \
"""Syntax of the fireworks language:
	
wait milliseconds
	wait 3000 --> waits for 3 seconds

fountain position [color:0-5] [lifetime:1-86400] [size:0.35-1.0]
	fountain 0.5 --> default fountain with random color in the middle
	fountain 0.25 color:0 size:1.0 --> extra large red fountain 1/4 to the left

rocket position [angle:-1.0-1.0] [arandom:0.0-1.0] [height:0.0-1.0] [hrandom:0.0-1.0]
						 [effect:explosion|cluster|glitter] [color:0-5]
	rocket 0.5 arandom:0 --> default rocket with random color in the middle going straight up
	rocket 0.5 angle:-1.0 arandom:1.0 --> rocket flies diagonal to the left with maximum random in angle

flare position [color:0-5] [lifetime:1-86400] [size:0.35-1.0]
	flare 0.5 lifetime:10 size:1.0 --> shoots balls from the middle into maximum height for 10 seconds

wheel position [height:0.0-1.0] [color:0-5] [count:2-10] [lifetime:1-86400] [size:0.2-1.0]
	wheel 0.5 color:0 count:5 --> a normal sized wheel with 5 boosters spins in the middle of the screen"""

const CONTINUE = "CONTINUE"
const WAIT = "WAIT"

func play_text(s: String):
	var x = s
	for k in s.split("\n"):
		var state = play_instruction(k)
		match state:
			CONTINUE:
				pass
			WAIT:
				yield(get_tree().create_timer(_cache_wait_time),"timeout")
				
		emit_signal("InstructionDone")
	yield(get_tree().create_timer(end_wait_time),"timeout")
	emit_signal("FireWorkDone")
	
var _cache_wait_time : float
func play_instruction(instruction):
	var result = instruction.split(" ", false)
	if result == null || result.size() < 2 || result[0].begins_with("#"):
		return CONTINUE
	
	var command = result[0].to_lower()
	if command == "fountain" || command == "rocket" || command == "flare" || command == "wheel":
		var x = float(result[1])
		var newFirework = load(firework_effects_path + command.capitalize() + ".tscn").instance()
		newFirework.position = Vector2(screen_width * x, screen_height)
		for i in range(2, result.size()):
			var set = result[i].split(":")
			if (set.size() == 2):
				newFirework.set_attribute(set[0], set[1])
		add_child(newFirework)
		return CONTINUE
	
	elif command == "wait":
		var time_ms = float(result[1])
		_cache_wait_time = time_ms/1000
		return WAIT
	else:
		return CONTINUE
#
#func _ready():
#	play_instruction("explosion")
