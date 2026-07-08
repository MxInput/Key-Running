extends Node

var place = 0;
@export var final_place = 10;

@export var place_display : RichTextLabel;

func _ready() -> void:
	place_display.text = "[wave]" + str(final_place - place) + " left";
	
func move_forward() -> void:
	place += 1;
	place_display.text = "[wave]" + str(final_place - place) + " left";
	
	if (place == final_place):
		place_display.text = "[wave] Complete"; 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
