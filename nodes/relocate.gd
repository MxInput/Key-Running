extends CharacterBody2D

var moving = false;
var current_pos;

const SPEED = 3.0;

func _process(delta: float) -> void:
	if (moving):
		position = position.move_toward(current_pos, SPEED)
		
		if (current_pos.x - position.x < 1 && current_pos.x - position.x > -1):
			if (current_pos.y - position.y < 1 && current_pos.y - position.y > -1):
				moving = false;
				position = current_pos;
