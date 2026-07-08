extends Node

var generated = false;
var answered = false;

var max_minuend = 100;
var max_addend = 9;

@export var problem_text : RichTextLabel;
var current_answer = -1;

@export var place_handler : Node;

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
	if event.is_action_pressed("1") && !answered:
		pickAnswer(1);
	elif event.is_action_pressed("2") && !answered:
		pickAnswer(2);
	elif event.is_action_pressed("3") && !answered:	
		pickAnswer(3);
	elif event.is_action_pressed("4") && !answered:
		pickAnswer(4);
	elif event.is_action_pressed("5") && !answered:
		pickAnswer(5);
	elif event.is_action_pressed("6") && !answered:
		pickAnswer(6);
	elif event.is_action_pressed("7") && !answered:
		pickAnswer(7);
	elif event.is_action_pressed("8") && !answered:
		pickAnswer(8);
	elif event.is_action_pressed("9") && !answered:
		pickAnswer(9);
	elif event.is_action_pressed("0") && !answered:
		pickAnswer(0);
	elif event.is_action_pressed("Space"):
		if (answered && generated):
			generated = false;
			answered = false;

func pickAnswer(answer : int) -> void:
	answered = true;
	
	problem_text.text += " = " + str(answer);
	
	if (answer == current_answer):
		problem_text.text += " Correct";
		
		place_handler.move_forward();
	else:
		problem_text.text += " Incorrect";
			
func _process(delta: float) -> void:
	if (!generated && place_handler.place < place_handler.final_place):
		var generated_nums = get_basic_sub();
		var generated_nums2 = get_basic_add();
		print(generated_nums2);
		problem_text.text = "[wave]" + str(generated_nums[1]) + " - " + str(generated_nums[2]);
		current_answer = generated_nums[0];
		generated = true;
		
