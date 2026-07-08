extends Sprite2D

@export var tiles : TileMapLayer;

@export var player : CharacterBody2D;

@export var generation : Node;

@export var place_display : RichTextLabel;

@export var reload_text : RichTextLabel;
@export var continue_text : RichTextLabel;

var current_row := 0;

func advance() -> void:
	current_row += 1;
	
	position = Vector2(tiles.to_global(tiles.map_to_local(Vector2i(current_row, 0))).x, position.y);
	
	for tile_y in tiles.bot_y + 2:
		tiles.set_cell(Vector2i(current_row, tile_y), 3, Vector2i(0,0));
	
	if (current_row >= player.current_row):
		generation.dead = true;
		
		TutorialStatus.losses += 1;
		TutorialStatus.last_won = false;
		
		place_display.text = "[tornado freq=15 radius=1] Game Over";
		place_display.modulate = Color(0.706, 0.188, 0.268, 1.0);
		
		continue_text.visible = false;
		reload_text.visible = true;
