extends Control

@onready var backbtn: Button = $TextureRect/backbtn

func _on_backbtn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
