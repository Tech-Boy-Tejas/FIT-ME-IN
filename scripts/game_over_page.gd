extends Control

@onready var restart: Button = $BG/Panel/btnContainer/restart
@onready var main_menu: Button = $BG/Panel/btnContainer/mainMenu
@onready var score_display: Label = $BG/Panel/scoreDisplay
@onready var highscore_display: Label = $BG/Panel/highscoreDisplay
@onready var fail_msg: Label = $BG/failMSG

const LINES := [
	"technically you fit",
	"close enough",
	"geometry: undefeated",
	"you left some of yourself behind",
]

func _ready() -> void:
	fail_msg.text = LINES.pick_random()

func _process(delta:float) -> void:
	score_display.text = "SCORE : " + str(ScoreHolder.score)
	highscore_display.text = "HIGHSCORE : " + str(ScoreHolder.highscore)

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_screen.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
