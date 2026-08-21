extends Node

@onready var propeller_texture : Texture2D = preload("res://images/propeller_hat.png");

var generated = false;
var answered = false;
var victory = false;

var selected_options := false;
var completed_tutorial := false;

const max_minuend = 100;
const max_addend = 9;

var include_add := false;

var include_min := false;

var include_mul := false;

var include_div := false;
var include_harder_div := false;

var include_sqrt := false;

var dead = false;

@export var problem_text : RichTextLabel;
@export var correct_text : RichTextLabel;

@export var place_handler : Node;

@export var cloud : Sprite2D;

@onready var timer = get_child(0);

@export var tutorial_screen : TextureRect;
@export var options_screen : TextureRect;

@export var continue_text : RichTextLabel;

@export var winLossTeller : ColorRect;

@export var player : CharacterBody2D;

@export var tiles : TileMapLayer;

var max_hard_addend := 9999;

var selected_problems = [];

var current_answer = -1;

func _ready() -> void:
	if (!TutorialStatus.tutorial):
		tutorial_screen.visible = true;
	else:
		options_screen.visible = true;
		
		var found_hat := player.find_child("Hat");
		found_hat.visible = true;
		
		if (!TutorialStatus.last_won):
			found_hat.texture = propeller_texture;
		
	if (TutorialStatus.wins > 0 || TutorialStatus.losses > 0):
		winLossTeller.visible = true;
		winLossTeller.get_child(0).text = "[wave]Number of Wins: " + str(TutorialStatus.wins) + "; Number of Losses: " + str(TutorialStatus.losses);
		 
func get_basic_sub() -> Array[int]:
	var answer = -1;
	var num1 = 0;
	var num2 = 0;
	
	while (answer < 0 || answer > 9):
		num1 = randi_range(0, max_minuend);
		num2 = randi_range(0, max_minuend);
		
		answer = num1 - num2;
	
	return [answer, num1, num2];
	
func get_basic_add() -> Array[int]:
	var answer = -1;
	var num1 = 0;
	var num2 = 0;
	
	while (answer < 0 || answer > 9):
		num1 = randi_range(0, max_addend);
		num2 = randi_range(0, max_addend);
		
		answer = num1 + num2;
	
	return [answer, num1, num2];
	
func get_basic_mul() -> Array[int]:
	var answer = -1;
	var num1 = 0;
	var num2 = 0;
	
	while (answer < 0 || answer > 9):
		num1 = randi_range(0, max_addend);
		num2 = randi_range(0, max_addend);
		
		answer = num1 * num2;
	
	return [answer, num1, num2];
	
func get_basic_div() -> Array[int]:
	var answer = -1;
	var num1 = 0;
	var num2 = 0;
	
	var has_remainder = true;
	
	while ((answer < 0 || answer > 9) || has_remainder):
		num1 = randi_range(0, max_minuend);
		num2 = randi_range(0, max_minuend);
		
		if (num2 == 0):
			continue;

		answer = num1 / num2;
		
		var remainder = num1 % num2

		if (remainder != 0):
			has_remainder = true;
		else:
			has_remainder = false;

	return [answer, num1, num2];
	
func get_longer_div() -> Array[int]:
	var answer = -1;
	var num1 = 0;
	var num2 = 0;
	
	var has_remainder = true;
	var reroll_count := 0;
	
	while ((answer < 0 || answer > 9) || has_remainder):
		num1 = randi_range(0, max_hard_addend);
		num2 = randi_range(0, max_hard_addend);
		
		if (num2 == 0):
			continue;

		answer = num1 / num2;
		
		var remainder = num1 % num2

		if (remainder != 0):
			has_remainder = true;
		else:
			has_remainder = false;
			
		if ((answer == 1 || answer == 0) && reroll_count < 50):
			reroll_count += 1;
			
			answer = -1;
			continue;
			
	return [answer, num1, num2];

func get_sqrt() -> Array[int]:
	var answer = -1;
	var num1 = 0;

	var reroll_count := 0;
	
	while ((answer < 0 || answer > 9)):
		num1 = randi_range(0, max_hard_addend);
		
		var square_root = sqrt(num1);
		
		if (!is_equal_approx(int(square_root), square_root)):
			continue;
			
		answer = int(square_root);

	return [answer, num1];
	
func _input(event) -> void:
	if (TutorialStatus.tutorial):
		if (selected_options || completed_tutorial):
			if event.is_action_pressed("1") && !answered && !dead && !victory:
				pickAnswer(1);
				
			elif event.is_action_pressed("2") && !answered && !dead && !victory:
				pickAnswer(2);
				
			elif event.is_action_pressed("3") && !answered && !dead && !victory:	
				pickAnswer(3);
				
			elif event.is_action_pressed("4") && !answered && !dead && !victory:
				pickAnswer(4);
				
			elif event.is_action_pressed("5") && !answered && !dead && !victory:
				pickAnswer(5);
				
			elif event.is_action_pressed("6") && !answered && !dead && !victory:
				pickAnswer(6);
				
			elif event.is_action_pressed("7") && !answered && !dead && !victory:
				pickAnswer(7);
				
			elif event.is_action_pressed("8") && !answered && !dead && !victory:
				pickAnswer(8);
				
			elif event.is_action_pressed("9") && !answered && !dead && !victory:
				pickAnswer(9);
				
			elif event.is_action_pressed("0") && !answered && !dead && !victory:
				pickAnswer(0);
				
			elif event.is_action_pressed("Space"):
				if (answered && generated):
					generated = false;
					answered = false;
					
					if (!dead && !victory):
						correct_text.visible = false;
						continue_text.visible = false;
					elif (dead || victory):
						timer.start();
		else:
			if event.is_action_pressed("Space"):
				include_add = options_screen.find_child("Addition").is_pressed();
				
				include_min = options_screen.find_child("Subtraction").is_pressed();
				
				include_div = options_screen.find_child("Division").is_pressed();
				include_harder_div = options_screen.find_child("HarderDivision").is_pressed();
				
				include_mul = options_screen.find_child("Multiplication").is_pressed();
				
				include_sqrt = options_screen.find_child("Sqrt").is_pressed();
				
				if (include_add || include_min || include_div || include_mul || include_harder_div || include_sqrt):
					selected_options = true;
					options_screen.visible = false;
									
					if (include_add):
						selected_problems.push_back(1);
					
					if (include_div):
						selected_problems.push_back(3);
					
					if (include_harder_div):
						selected_problems.push_back(4);
							
					if (include_min):
						selected_problems.push_back(0);
						
					if (include_mul):
						selected_problems.push_back(2);
						
					if (include_sqrt):
						selected_problems.push_back(5);
				else:
					options_screen.find_child("Warn").visible = true;
	else:
		if event.is_action_pressed("Space"):
			include_add = tutorial_screen.find_child("Addition").is_pressed();
			
			include_min = tutorial_screen.find_child("Subtraction").is_pressed();
			
			include_div = tutorial_screen.find_child("Division").is_pressed();
			include_harder_div = tutorial_screen.find_child("HarderDivision").is_pressed();
			
			include_mul = tutorial_screen.find_child("Multiplication").is_pressed();
			
			include_sqrt = tutorial_screen.find_child("Sqrt").is_pressed();
			
			if (include_add || include_min || include_div || include_mul || include_harder_div || include_sqrt):
				TutorialStatus.tutorial = true;
				tutorial_screen.visible = false;
				
				completed_tutorial = true;
				
				if (include_add):
					selected_problems.push_back(1);
				
				if (include_div):
					selected_problems.push_back(3);
					
				if (include_harder_div):
					selected_problems.push_back(4);
						
				if (include_min):
					selected_problems.push_back(0);
					
				if (include_mul):
					selected_problems.push_back(2);
					
				if (include_sqrt):
					selected_problems.push_back(5);
			else:
				tutorial_screen.find_child("Warn").visible = true;
			
func pickAnswer(answer : int) -> void:
	answered = true;
	
	problem_text.text += " = " + str(answer);
	
	correct_text.visible = true;
	continue_text.visible = true;
	
	if (answer == current_answer):	
		correct_text.text = "[wave]Correct";
		correct_text.modulate = Color(0.253, 0.588, 0.49, 1.0);
		
		place_handler.move_forward();
	else:
		TutorialStatus.perfect = false;

		correct_text.text = "[wave]Incorrect";
		correct_text.modulate = Color(0.706, 0.188, 0.268, 1.0);
		tiles.set_cell(tiles.local_to_map(tiles.to_local(player.position)), 2, Vector2i(0,0))
		
	cloud.advance();
			
func _process(delta: float) -> void:
	if (!generated && place_handler.place < place_handler.final_place && !dead && (completed_tutorial || selected_options)):
		var generated_nums
		var rand_choice = selected_problems.pick_random();
			
		match (rand_choice):
			0:
				generated_nums = get_basic_sub();
				problem_text.text = "[wave]" + str(generated_nums[1]) + " - " + str(generated_nums[2]);
			1:
				generated_nums = get_basic_add();
				problem_text.text = "[wave]" + str(generated_nums[1]) + " + " + str(generated_nums[2]);
			2:
				generated_nums = get_basic_mul();
				problem_text.text = "[wave]" + str(generated_nums[1]) + " * " + str(generated_nums[2]);
			3:
				generated_nums = get_basic_div();
				problem_text.text = "[wave]" + str(generated_nums[1]) + " / " + str(generated_nums[2]);
			4:
				generated_nums = get_longer_div();
				problem_text.text = "[wave]" + str(generated_nums[1]) + " / " + str(generated_nums[2]);
			5:
				generated_nums = get_sqrt();
				problem_text.text = "[wave]SQRT(" + str(generated_nums[1]) + ")";
				
		current_answer = generated_nums[0];
		generated = true;

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene();
