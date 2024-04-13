class_name Main
extends Node2D

const OPEN_HAND = preload("res://assets/hand1.png");
const CLOSED_HAND = preload("res://assets/hand2.png");
const LOWER_LEFT = Vector2(512, 0);

@onready var hand_sprite_2d: Sprite2D = $HandSprite2D
@onready var catchable_controller: Node2D = $CatchableController
@onready var spawn_timer: Timer = $CatchableController/SpawnTimer
@onready var start_timer: Timer = $StartTimer
@onready var countdown_timer: Timer = $CountdownTimer
@onready var reset_button: Button = $Control/ResetButton

@onready var countdown_label: Label = $Control/Countdown

enum PHASE {START, STARTED, PLAY, END};

var isGrabbing = false;
var phase = PHASE.START;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN);

	start_timer.timeout.connect(handle_start_end, CONNECT_ONE_SHOT);
	start_timer.start();
	pass # Replace with function body.

func handle_start_end():
	phase = PHASE.STARTED;
	countdown_label.text = "GO!";
	spawn_timer.start();
	countdown_timer.timeout.connect(handle_countdown_end, CONNECT_ONE_SHOT);
	countdown_timer.start();

	start_timer.wait_time = 1;
	start_timer.timeout.connect(handle_start_end_2, CONNECT_ONE_SHOT);
	start_timer.start();
	return;

func handle_start_end_2():
	phase = PHASE.PLAY;
	countdown_label.text = "";
	return;

func handle_countdown_end():
	phase = PHASE.END;
	spawn_timer.stop();
	catchable_controller.delete_all();
	countdown_label.text = "FINISHED!!";

	# show reset button
	reset_button.pressed.connect(handle_reset_button, CONNECT_ONE_SHOT);
	reset_button.show();

	return;

func handle_reset_button():
	phase = PHASE.START;
	reset_button.hide();

	start_timer.wait_time = 3;
	start_timer.timeout.connect(handle_start_end, CONNECT_ONE_SHOT);
	start_timer.start();
	return;

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1:
			isGrabbing = event.pressed
			handleButtonChange(event.pressed);

func handleButtonChange (pressed) -> void:
	if (pressed):
		$HandSprite2D.texture = CLOSED_HAND
	else:
		$HandSprite2D.texture = OPEN_HAND

const FOLLOW_SPEED = 4.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match phase:
		PHASE.START:
			var time_left = ceil(start_timer.time_left);
			countdown_label.text = str(time_left);
		PHASE.PLAY:
			var time_left = ceil(countdown_timer.time_left);
			countdown_label.text = str(time_left);



	var mousePos: Vector2 = get_viewport().get_mouse_position();
	$HandSprite2D.position = mousePos;
	$HandSprite2D.rotation = (LOWER_LEFT - mousePos).angle();
	pass
