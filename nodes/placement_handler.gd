extends Node

var place = 0;
@export var final_place = 13;

@export var place_display : RichTextLabel;

@export var player : CharacterBody2D;

@export var tiles : TileMapLayer;

func _ready() -> void:
	place_display.text = "[wave]" + str(final_place - place) + " left";
	
func move_forward() -> void:
	place += 1;
	place_display.text = "[wave]" + str(final_place - place) + " left";
	
	if (place == final_place):
		place_display.text = "[wave] Complete"; 
		
	player.moving = true;
	player.current_pos = tiles.selected_tiles[place - 1];
