class_name Pillar
extends Node2D

const WIDTH := 120.0
const OVERHANG := 500.0

var upper_poly: PackedVector2Array
var lower_poly: PackedVector2Array
var passed := false

var _upper := Polygon2D.new()
var _lower := Polygon2D.new()
var _upper_col := CollisionPolygon2D.new()
var _lower_col := CollisionPolygon2D.new()


func _ready() -> void:
	var body := StaticBody2D.new()
	body.add_child(_upper_col)
	body.add_child(_lower_col)
	add_child(body)

	for p in [_upper, _lower]:
		p.color = Color("c0392b")
		add_child(p)


func shape(screen_h: float, gap_h: float, slant: float) -> void:
	var margin := 70.0
	var cy := randf_range(margin + gap_h * 0.5, screen_h - margin - gap_h * 0.5)
	var tilt := randf_range(-slant, slant)      
	var taper := randf_range(0.5, 1.1)         

	var lt := cy - gap_h * 0.5 + tilt
	var lb := cy + gap_h * 0.5 + tilt
	var rt := cy - gap_h * taper * 0.5 - tilt
	var rb := cy + gap_h * taper * 0.5 - tilt

	upper_poly = PackedVector2Array([
		Vector2(0.0, -OVERHANG), Vector2(WIDTH, -OVERHANG),
		Vector2(WIDTH, rt), Vector2(0.0, lt),
	])
	lower_poly = PackedVector2Array([
		Vector2(0.0, lb), Vector2(WIDTH, rb),
		Vector2(WIDTH, screen_h + OVERHANG), Vector2(0.0, screen_h + OVERHANG),
	])

	_upper.polygon = upper_poly
	_lower.polygon = lower_poly
	_upper_col.polygon = upper_poly
	_lower_col.polygon = lower_poly
	passed = false


func overlaps_x(lo: float, hi: float) -> bool:
	var left := global_position.x
	return hi > left and lo < left + WIDTH
