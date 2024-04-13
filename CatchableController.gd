extends Node2D

const CatchableScene = preload("res://catchable.tscn");
const BUG_TEXTURE = preload("res://assets/catchables1.png");
const YARN_TEXTURE = preload("res://assets/catchables2.png");
const CACTUS_TEXTURE = preload("res://assets/catchables3.png");
const TRAP_TEXTURE = preload("res://assets/catchables4.png");

const MAP_SIZE = 512;
const SPEED = 1.5;

@export_category("Points")
@export var MISSED_CLICK = -25;
@export var LOST_CATCHABLE = -100;

@onready var main: Node2D = $".."
@onready var hand_area: Area2D = $"../HandSprite2D/Area2D";
@onready var label: Label = $"../Control/Points";
@onready var container: Node2D = $Container;
@onready var spawn_timer: Timer = $SpawnTimer;

var textures = [BUG_TEXTURE, YARN_TEXTURE, CACTUS_TEXTURE, TRAP_TEXTURE];
var catchableSprites = [];
var points = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.timeout.connect(handle_spawn);
	#spawn_timer.start();
	return;

func handle_spawn():
	var catchable = create_catchable();
	catchableSprites.push_front(catchable);
	container.add_child(catchable);
	return;

# incentivize clicking late, add a bonus like points += catchable.position.distance_to(center) *.5 - fubar
func _input(event: InputEvent) -> void:
	if (main.phase == Main.PHASE.PLAY && event is InputEventMouseButton):
		if (event.button_index == 1 && event.pressed):
			var areas: Array[Area2D] = hand_area.get_overlapping_areas() as Array[Area2D];
			if (areas.size() == 0):
				points += MISSED_CLICK;
			else:
				for area in areas:
					var catchable: Catchable = area.get_parent();
					points += catchable.get_points();
					delete_catchable(catchable);
			label.text = str(points);
	return;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for catchable in catchableSprites:
		if (
			catchable.position.x < 0 ||
			catchable.position.x > MAP_SIZE ||
			catchable.position.y < 0 ||
			catchable.position.y > MAP_SIZE):
			points += LOST_CATCHABLE;
			label.text = str(points);
			delete_catchable(catchable);
			return;
	return;

func create_catchable() -> Catchable:
	var catchable: Catchable = CatchableScene.instantiate();
	catchable.type = randi_range(0, 1);
	catchable.texture = textures[catchable.type];
	catchable.position.x = randi_range(128, 384);
	catchable.position.y = randi_range(128, 384);
	catchable.speed = randf_range(1.5, 2.5);
	return catchable;

func delete_catchable(catchable: Catchable) -> void:
	catchableSprites.remove_at(catchableSprites.find(catchable));
	catchable.queue_free();
	return;

func delete_all() -> void:
	for catchable in catchableSprites:
		delete_catchable(catchable);
	return;
