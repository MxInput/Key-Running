extends Sprite2D

@export var tiles : TileMapLayer;

@export var player : CharacterBody2D;

@export var generation : Node;

@export var place_display : RichTextLabel;

var current_row = 0;

@export var reload_text : RichTextLabel;

@export var continue_text : RichTextLabel;

func advance() -> void:
	current_row += 1;
	
	position = Vector2(tiles.to_global(tiles.map_to_local(Vector2i(current_row, 0))).x, position.y);
	
	for tile_y in tiles.boty + 2:
		tiles.set_cell(Vector2i(current_row, tile_y), 3, Vector2i(0,0));
	
	if (current_row >= player.current_row):
		generation.dead = true;
		place_display.text = "[wave] Game Over";
		continue_text.visible = false;
		
		reload_text.visible = true;
