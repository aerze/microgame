extends Node2D

const OPEN_HAND = preload("res://assets/hand1.png");
const CLOSED_HAND = preload("res://assets/hand2.png");
const LOWER_LEFT = Vector2(512, 0);

@onready var hand_sprite_2d: Sprite2D = $HandSprite2D

var isGrabbing = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN);
	pass # Replace with function body.

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
	var mousePos: Vector2 = get_viewport().get_mouse_position()
	$HandSprite2D.position = mousePos;
	$HandSprite2D.rotation = (LOWER_LEFT - mousePos).angle();
	pass
