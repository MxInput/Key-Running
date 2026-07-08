extends Node

var place = 0;
@export var final_place = 13;

@export var place_display : RichTextLabel;

@export var player : CharacterBody2D;

@export var tiles : TileMapLayer;

@export var generation : Node;

@export var reload_text : RichTextLabel;

@export var continue_text : RichTextLabel;

func _ready() -> void:
	place_display.text = "[wave]" + str(final_place - place) + " questions left";
	
func move_forward() -> void:
	place += 1;
	place_display.text = "[wave]" + str(final_place - place) + " questions left";
	
	if (place == final_place):
		TutorialStatus.wins += 1;
		TutorialStatus.last_won = true;

		place_display.text = "[wave] Complete"; 
		generation.victory = true;
		
		reload_text.visible = true;
		continue_text.visible = false;
		
	player.moving = true;
	player.current_pos = tiles.selected_tiles[place - 1];
