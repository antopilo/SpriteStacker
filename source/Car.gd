extends KinematicBody2D

onready var Trail = get_node("Trail")
var path = "res://Content/RaceCar/"
export var SpriteCount = 8;
export var offset = 1;
export(float) var scal = 1
var sprites = []
var angle = 0
var speed = 1

var DriftMotion = Vector2()

func _ready():
	makeSprite()
	position = Vector2(320 / 2, 180 / 2)

func _physics_process(delta):
	for sprite in sprites:
		sprite.rotation_degrees = angle
	
	if Input.is_action_pressed("ui_up") and speed < 200:
		speed += 1
		$Trail.emitting = false
	elif Input.is_action_pressed("ui_down") and speed > -50:
		speed -= 1
		$Trail.emitting = true
	else:
		$Trail.emitting = false
	
	if Input.is_action_pressed("ui_right"):
		angle += 2
	if Input.is_action_pressed("ui_left"):
		angle -= 2
	
	move_and_slide(Vector2(cos(deg2rad(angle)), sin(deg2rad(angle))) * speed)

	update()
	
func makeSprite():
	for i in SpriteCount:
		var currentSprite = Sprite.new()
		currentSprite.texture = ResourceLoader.load( path + str(i) + ".png")
		currentSprite.position.y -= i * offset
		add_child(currentSprite)
		sprites.append(currentSprite)
		
func _draw():
	var a = deg2rad(angle)
	var TargetVector = Vector2(cos(a), sin(a)) * 25
	draw_line( Vector2(), TargetVector, ColorN("red"))