extends Sprite2D

@export var tiles : TileMapLayer;

var current_row = 0;

func advance() -> void:
	current_row += 1;
	
	position = Vector2(tiles.to_global(tiles.map_to_local(Vector2i(current_row, 0))).x, position.y);
	
	for tile_y in tiles.boty + 2:
		tiles.set_cell(Vector2i(current_row, tile_y), 3, Vector2i(0,0));
