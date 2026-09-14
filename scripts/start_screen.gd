extends Control

@onready var flash: ColorRect = $flash

func _ready() -> void:
	flash.color = Color(1,1,1,0)
	flash.visible = false

func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	flash.visible = true
	var tween = flash.create_tween()
	tween.tween_property(flash,"color:a",1.0,1.0)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/game_screen.tscn")


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tutorialscreen.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
