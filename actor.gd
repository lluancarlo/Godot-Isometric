extends CharacterBody2D


@onready var _anim := $AnimatedSprite2D as AnimatedSprite2D
@onready var _animTree := $AnimationTree as AnimationTree
var speed = 500


func _physics_process(delta: float) -> void:
	get_input()
	move_and_collide(velocity * delta)


func get_input() -> void:
	var input_dir = Input.get_vector("left", "right", "up", "down")
	velocity = input_dir * speed
	set_animation(input_dir)


func set_animation(pos: Vector2) -> void:
	#print(_animTree.get("parameters/walk/blend_position"))
	
	if pos != Vector2.ZERO:
		pos.y *= -1
		_animTree.set("parameters/conditions/isIdle", false)
		_animTree.set("parameters/conditions/isWalking", true)
		_animTree.set("parameters/walk/blend_position", pos)
		_animTree.set("parameters/idle/blend_position", pos)
	else:
		_animTree.set("parameters/conditions/isWalking", false)
		_animTree.set("parameters/conditions/isIdle", true)


func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.is_pressed():
			spawn_icon(get_global_mouse_position())


func spawn_icon(pos: Vector2) -> void:
	var s = Sprite2D.new()
	s.texture = load("res://icon.svg")
	s.scale = Vector2(0.4, 0.4)
	get_parent().add_child(s)
	s.position = pos
	var call = func(s): s.queue_free()
	get_tree().create_timer(2).timeout.connect(call.bind(s))
