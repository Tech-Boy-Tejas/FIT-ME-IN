class_name Blob
extends Node2D

signal died
signal carved(amount_lost: float)

const GRAVITY := 1450.0
const FLAP := -500.0
const DEAD_AT := 0.1     # fraction of starting area below which you're gone
const SIZE := 60

var poly: PackedVector2Array
var vel := -100.0
var start_area := 0.0
var alive := true

var _view := Polygon2D.new()
var _outline = Line2D.new()

var frozen := true

func _ready() -> void:
	_view.color = Color.WHITE
	_view.texture = preload("res://assets/bluedove_blob_120 (3).png")
	_view.texture_offset = Vector2(SIZE,SIZE)
	_view.texture_scale = Vector2.ONE
	add_child(_view)
	
	_outline.width = 5.0
	_outline.default_color = Color("f5a623")
	_outline.closed = true 
	_outline.joint_mode = Line2D.LINE_JOINT_ROUND
	add_child(_outline)
	
	reset()


func reset() -> void:
	poly = PackedVector2Array([
		Vector2(-SIZE, -SIZE), Vector2(SIZE, -SIZE),
		Vector2(SIZE, SIZE), Vector2(-SIZE, SIZE),
	])
	start_area = polygon_area(poly)
	vel = 0.0
	alive = true
	_view.polygon = poly
	_outline.points = poly if poly.size() >= 3 else PackedVector2Array()
	
func _physics_process(delta: float) -> void:
	if frozen or not alive:
		return
	if Input.is_action_just_pressed("ui_accept"):
		vel = FLAP
	vel += GRAVITY * delta
	position.y += vel * delta


func remaining() -> float:
	return 0.0 if poly.size() < 3 else polygon_area(poly) / start_area

func x_bounds() -> Vector2:
	if poly.size() == 0:
		return Vector2(global_position.x, global_position.x)
	var lo := INF
	var hi := -INF
	for p in poly:
		var gx := global_position.x + p.x
		lo = minf(lo, gx)
		hi = maxf(hi, gx)
	return Vector2(lo, hi)

func carve(solid: PackedVector2Array, xform: Transform2D) -> void:
	if not alive or poly.size() < 3:
		return

	var local := PackedVector2Array()
	for p in solid:
		local.append(to_local(xform * p))

	var before := polygon_area(poly)
	var pieces := Geometry2D.clip_polygons(poly, local)

	var best := PackedVector2Array()
	var best_area := 0.0
	for piece in pieces:
		if Geometry2D.is_polygon_clockwise(piece):
			continue
		var a := polygon_area(piece)
		if a > best_area:
			best_area = a
			best = piece

	poly = best
	_view.polygon = poly
	_outline.points = poly if poly.size() >= 3 else PackedVector2Array()

	var lost := before - best_area
	if lost > 1.0:
		carved.emit(lost / start_area)

	if remaining() < DEAD_AT:
		alive = false
		died.emit()


static func polygon_area(p: PackedVector2Array) -> float:
	if p.size() < 3:
		return 0.0
	var a := 0.0
	var g : PackedVector2Array
	g = p
	g.append(p[0])
	for i in g.size() - 1:
		a += g[i].x * g[i+1].y - g[i].y * g[i+1].x 
	return absf(a) * 0.5
