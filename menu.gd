extends Node2D

@onready var start_button: Button = $CanvasLayer/Control/CenterContainer/VBoxContainer/StartButton
@onready var exit_button: Button = $CanvasLayer/Control/CenterContainer/VBoxContainer/ExitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.pressed.connect(handle_start_button)
	exit_button.pressed.connect(handle_exit_button)
	pass # Replace with function body.

func handle_start_button():
	get_tree().change_scene_to_file("res://main.tscn")
	return;

func handle_exit_button():
	get_tree().quit();
	return;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
