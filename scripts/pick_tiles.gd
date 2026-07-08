extends TileMapLayer

@export var top_y : int;
@export var bot_y : int;

@export var top_x : int;
@export var bot_x : int;

var selected_tiles = [];

func _ready() -> void:
	var num_tiles = top_x - bot_x + 1;
	
	for tile in num_tiles:
		var y_val = randi_range(top_y, bot_y);
		
		set_cell(Vector2i(bot_x + tile, y_val), 1, Vector2i(0,0));
		selected_tiles.push_back(to_global(map_to_local(Vector2i(bot_x + tile, y_val))));
