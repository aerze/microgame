extends Node2D

const CatchableScene = preload("res://catchable.tscn");
const BUG_TEXTURE = preload("res://assets/catchables1.png");
const YARN_TEXTURE = preload("res://assets/catchables2.png");
const CACTUS_TEXTURE = preload("res://assets/catchables3.png");
const TRAP_TEXTURE = preload("res://assets/catchables4.png");


const MAP_SIZE = 512;
const SPEED = 1.5;

@onready var hand_area: Area2D = $"../HandSprite2D/Area2D"
@onready var label: Label = $"../Control/Points"
@onready var timer: Timer = $Timer
@onready var container: Node2D = $Container

var textures = [BUG_TEXTURE, YARN_TEXTURE, CACTUS_TEXTURE, TRAP_TEXTURE];
var catchableSprites = [];
var hover_handing: Catchable = null;
var points = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(handle_spawn);
	timer.start();
	pass # Replace with function body.

func handle_spawn():
	var catchable = create_catchable();
	catchableSprites.push_front(catchable);
	container.add_child(catchable);
	return;

func handle_mouse_enter(node: Node2D):
	hover_handing = node;
	pass;

func handle_mouse_exit(node: Node2D):
	hover_handing = null;
	pass;

# incentivize clicking late, add a bonus like points += catchable.position.distance_to(center) *.5 - fubar
func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		if (event.button_index == 1 && event.pressed):
			var areas: Array[Area2D] = hand_area.get_overlapping_areas() as Array[Area2D];
			if (areas.size() == 0):
				points-= 25;
			else:
				for area in areas:
					var catchable: Catchable = area.get_parent();
					var points_awarded = int(catchable.position.distance_to(Vector2(MAP_SIZE/2, MAP_SIZE/2)) *.5)
					points += points_awarded;
					delete_catchable(catchable);
			label.text = str(points);
	return;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for catchable in catchableSprites:
		match catchable.type:
			0:
				scatter(catchable);
			1:
				line(catchable);
			2:
				roll(catchable);
			3:
				pop_up(catchable);

		if (
			catchable.position.x < 0 ||
			catchable.position.x > MAP_SIZE ||
			catchable.position.y < 0 ||
			catchable.position.y > MAP_SIZE):
			points -= 25;
			delete_catchable(catchable);
			pass;
	pass

func create_catchable() -> Catchable:
	var catchable: Catchable = CatchableScene.instantiate();
	catchable.type = randi_range(0, 0);
	catchable.texture = textures[catchable.type];
	catchable.position.x = randi_range(128, 384);
	catchable.position.y = randi_range(128, 384);
	catchable.speed = randi_range(1.5, 2.5);
	var area2d: Area2D = catchable.get_node("Area2D") as Area2D;
	area2d.mouse_entered.connect(handle_mouse_enter.bind(catchable));
	area2d.mouse_exited.connect(handle_mouse_exit.bind(catchable));
	return catchable;

func delete_catchable(catchable: Catchable) -> void:
	catchableSprites.remove_at(catchableSprites.find(catchable));
	catchable.queue_free();
	pass;

func scatter(c:Catchable) -> void:
	c.position += c.direction * c.speed;
	return;

func line(c:Catchable) -> void:
	c.position.x += -SPEED;
	return;

func roll(c:Catchable) -> void:
	c.position.y += SPEED;
	return;

func pop_up(c:Catchable) -> void:
	c.position.y += -SPEED;
	return;
