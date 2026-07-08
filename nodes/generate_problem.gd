extends Node

var generated = false;
var answered = false;
var victory = false;

var finished_tutorial = false;

var max_minuend = 100;
var max_addend = 9;

var dead = false;

@export var problem_text : RichTextLabel;
@export var correct_text : RichTextLabel;
var current_answer = -1;

@export var place_handler : Node;

@export var cloud : Sprite2D;

@onready var timer = get_child(0);

@export var tutorial_screen : TextureRect;

func _ready() -> void:
	if (!finished_tutorial):
		tutorial_screen.visible = true;
		
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
	
func _input(event) -> void:
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
			elif (dead || victory):
				timer.start();

func pickAnswer(answer : int) -> void:
	answered = true;
	
	problem_text.text += " = " + str(answer);
	
	correct_text.visible = true;
	
	if (answer == current_answer):	
		correct_text.text = "[wave]Correct";
		correct_text.modulate = Color(0.253, 0.588, 0.49, 1.0);
		
		place_handler.move_forward();
	else:
		correct_text.text = "[wave]Incorrect";
		correct_text.modulate = Color(0.706, 0.188, 0.268, 1.0);
		
	cloud.advance();
			
func _process(delta: float) -> void:
	if (!generated && place_handler.place < place_handler.final_place && !dead):
		var generated_nums
		var rand_choice = randi_range(0, 1);
			
		match (rand_choice):
			0:
				generated_nums = get_basic_sub();
				problem_text.text = "[wave]" + str(generated_nums[1]) + " - " + str(generated_nums[2]);
			1:
				generated_nums = get_basic_add();
				problem_text.text = "[wave]" + str(generated_nums[1]) + " + " + str(generated_nums[2]);
		
		current_answer = generated_nums[0];
		generated = true;

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene();
