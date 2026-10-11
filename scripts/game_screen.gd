extends Node2D

@export var blob_path: NodePath

const BASE_SPEED := 190.0
const MAX_SPEED := 430.0

var blob: Blob
var live: Array[Pillar] = []
var pool: Array[Pillar] = []
var spawn_x := 0.0
var speed := BASE_SPEED
var sholder := ScoreHolder.new()
var playing := true
var screen: Vector2

@onready var clouds_far: Parallax2D = $CanvasLayer/CloudsFar
@onready var birds_far: Parallax2D = $CanvasLayer/BirdsFar
@onready var clouds_near: Parallax2D = $CanvasLayer/CloudsNear
@onready var birds_near: Parallax2D = $CanvasLayer/BirdsNear
@onready var fade: ColorRect = $CanvasLayer/Fade
@onready var scorelabel: Label = $Score
@onready var highscorelabel: Label = $Highscore
@onready var healthlabel: Label = $Health
@onready var start_msgLabel: Label = $startMSG
@onready var menu_btn: Button = $menuBtn
@onready var prompt_msgLabel: Label = $promptMSG

var started := false

func _ready() -> void:
	screen = get_viewport_rect().size
	blob = get_node(blob_path)
	blob.died.connect(_on_died)
	blob.position = Vector2(150.0, screen.y * 0.5)
	spawn_x = screen.x + 40.0
	
	fade.color.a = 0.0
	
	scorelabel.text = "SCORE : 0"
	healthlabel.text = "HEALTH : 100%"
	start_msgLabel.text = "PRESS SPACE TO START"
	start_msgLabel.visible = true
	prompt_msgLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_msgLabel.text = "FIND OUT WHAT HAPPENS WHEN YOU COLLIDE WITH A PILLAR\nSOMETHING CRAZYY"
	prompt_msgLabel.visible = true
	
	sholder.score = 0

func _process(delta: float) -> void:
	var m = minf(1 + float(sholder.score)/25.0,15.0)
	setSpeed(m)
	
	if not sholder.highscore:
		sholder.highscore = sholder.score
	elif sholder.score >= sholder.highscore:
		sholder.highscore = sholder.score
		
	scorelabel.text = "SCORE : " + str(sholder.score)
	highscorelabel.text = "HIGHSCORE : " + str(sholder.highscore)
	
	healthlabel.text = "HEALTH : " + str(int(100 * blob.remaining())) + "%"
	
func setSpeed(m : float) -> void:
	clouds_far.autoscroll.x = -6.0 * m
	birds_far.autoscroll.x = -14.0 * m
	clouds_near.autoscroll.x = -18.0 * m
	birds_near.autoscroll.x = -34.0 * m

func _physics_process(delta: float) -> void:
	
	if not started:
		if Input.is_action_just_pressed("ui_accept"):
			started = true
			blob.frozen = false
			blob.vel = blob.FLAP
		return
	
	start_msgLabel.visible = false
	prompt_msgLabel.visible = false
	if blob.alive and blob.position.y > 1080:
		playing = false
		var tween = create_tween()
		tween.tween_property(fade, "color:a",1.0,0.8)
		await tween.finished
		get_tree().change_scene_to_file("res://scenes/game_over_page.tscn")
	
	if not playing:
		if Input.is_action_just_pressed("ui_accept"):
			_restart()
		return

	speed = minf(MAX_SPEED, BASE_SPEED + sholder.score * 9.0)
	var dx := speed * delta

	for p in live:
		p.position.x -= dx
	spawn_x -= dx

	if spawn_x <= screen.x:
		_place(screen.x + 40.0)
		spawn_x = screen.x + 67.0 + maxf(380.0, 570.0 - sholder.score * 6.7)

	var bounds := blob.x_bounds()

	for p in live.duplicate():
		# carve first, while the blob is inside the band
		if p.overlaps_x(bounds.x, bounds.y):
			blob.carve(p.upper_poly, p.global_transform)
			blob.carve(p.lower_poly, p.global_transform)

		if not p.passed and p.position.x + Pillar.WIDTH < blob.global_position.x:
			p.passed = true
			sholder.score += 1

		if p.position.x + Pillar.WIDTH < -80.0:
			live.erase(p)
			p.hide()
			p.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
			pool.append(p)

	_carve_bounds()


func _place(x: float) -> void:
	var p: Pillar
	if pool.is_empty():
		p = Pillar.new()
		add_child(p)
	else:
		p = pool.pop_back()
		p.show()
		p.process_mode = Node.PROCESS_MODE_INHERIT

	var gap_h := maxf(250.0, 480.0 - sholder.score * 9.2)
	var slant := minf(110.0, 24.0 + sholder.score * 3.7)
	p.shape(screen.y, gap_h, slant)
	p.position.x = x
	live.append(p)


func _carve_bounds() -> void:
	var ceiling := PackedVector2Array([
		Vector2(-200.0, -600.0), Vector2(screen.x + 200.0, -600.0),
		Vector2(screen.x + 200.0, 0.0), Vector2(-200.0, 0.0),
	])
	var floor_poly := PackedVector2Array([
		Vector2(-200.0, screen.y), Vector2(screen.x + 200.0, screen.y),
		Vector2(screen.x + 200.0, screen.y + 600.0), Vector2(-200.0, screen.y + 600.0),
	])
	blob.carve(ceiling, Transform2D.IDENTITY)
	blob.carve(floor_poly, Transform2D.IDENTITY)


func _on_died() -> void:
	playing = false
	var tween = create_tween()
	tween.tween_property(fade, "color:a",1.0,0.8)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/game_over_page.tscn")


func _restart() -> void:
	for p in live:
		p.hide()
		pool.append(p)
	live.clear()
	spawn_x = screen.x + 40.0
	sholder.score = 0
	speed = BASE_SPEED
	blob.reset()
	blob.position = Vector2(150.0, screen.y * 0.5)
	playing = true


func _on_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_screen.tscn")
	
