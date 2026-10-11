class_name Pillar
extends Node2D

const WIDTH := 120.0
const OVERHANG := 500.0

var upper_poly: PackedVector2Array
var lower_poly: PackedVector2Array
var passed := false

var _upper := Polygon2D.new()
var _lower := Polygon2D.new()

var _pillarText := Label.new()

func _ready() -> void:
	for p in [_upper, _lower]:
		p.color = Color("c0392b")
		add_child(p)
	
	_pillarText.text = "GOOD FOOD"
	_pillarText.add_theme_font_size_override("font_size",26)
	_pillarText.add_theme_color_override("font_color",Color("f7e7d5"))
	_pillarText.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_pillarText.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_pillarText.size = Vector2(240,44)
	_pillarText.pivot_offset = _pillarText.size * 0.5
	_pillarText.rotation = -PI/2
	add_child(_pillarText)


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
	passed = false

	var upper_h := (lt + rt)*0.5
	var lower_h := screen_h - (lb + rb) * 0.5
	
	var mid : float
	if upper_h >= lower_h:
		mid = upper_h * 0.5
	else :
		mid = (lb + rb) * 0.5 + lower_h * 0.5
	
	_pillarText.position = Vector2(WIDTH * 0.5, mid) - _pillarText.pivot_offset
	_pillarText.visible = maxf(upper_h,lower_h) > 380.0

func overlaps_x(lo: float, hi: float) -> bool:
	var left := global_position.x
	return hi > left and lo < left + WIDTH
