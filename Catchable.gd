class_name Catchable extends Sprite2D

@onready var decision_timer: Timer = $Timer

enum Type {BUG, YARN, CACTUS, TRAP};

const MAP_SIZE = 512;

var type: int = Type.BUG;
var direction: Vector2 = Vector2(randf(), randf());
var speed: float = randf_range(1.5, 2.5);
var default_points: int = 0;

func get_points() -> int:
	match type:
		Type.BUG:
			# distance to center of game - fubar
			return int(position.distance_to(Vector2(MAP_SIZE/2, MAP_SIZE/2)) *.5);
		_:
			return default_points;

func _ready() -> void:
	decision_timer.timeout.connect(handle_timer)
	decision_timer.start();

	match type:
		Type.YARN:
			default_points = 50;
			direction = Vector2(randf_range(-1, 1), randf_range(-1, 1));
			speed = randf_range(3, 5);
	return;

func _process(delta: float) -> void:
	position += direction * speed;
	return;

func handle_timer() -> void:
	match type:
		Type.BUG:
			direction = Vector2(randf_range(-1, 1), randf_range(-1, 1));
			speed = randf_range(2.5, 3.5);
	return;
