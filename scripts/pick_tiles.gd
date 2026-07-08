extends TileMapLayer

@export var topy : int;
@export var boty : int;

@export var topx : int;
@export var botx : int;

var selected_tiles = [];

func _ready() -> void:
	var num_tiles = topx - botx + 1;
	
	for tile in num_tiles:
		var y_val = randi_range(topy, boty);
		
		set_cell(Vector2i(botx + tile, y_val), 1, Vector2i(0,0));
		selected_tiles.push_back(to_global(map_to_local(Vector2i(botx + tile, y_val))));
