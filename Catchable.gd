class_name Catchable extends Sprite2D

@onready var timer: Timer = $Timer

var type: int = 0;
var direction: Vector2 = Vector2(randf(), randf());
var speed: int = randi_range(1.5, 2.5);;


func _ready() -> void:
	timer.timeout.connect(handle_timer)
	timer.start();
	return;


func handle_timer() -> void:
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1));
	speed = randi_range(2.5, 3.5);
	return;
