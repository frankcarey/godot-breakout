extends Node

@onready var paddle = $Paddle
@onready var ball = $Ball
@onready var killZone = $"Field/KillZone"
@onready var bricks = $Bricks

const paddle_speed = 300.0
const ball_speed = 300.0

var brick_count
var current_level = 1

func _ready() -> void:
    reset_level()
    reset_paddle()
    
func reset_level(level: int = 0):
    if not level:
        level = current_level
    var level_resource: PackedScene = preload("res://level_1.tscn")
    var lv = level_resource.instantiate()
    bricks.queue_free()
    add_child(lv)
    bricks = lv
    
    brick_count = bricks.get_child_count()
    for brick in bricks.get_children():
        brick.connect(&"BrickDestroyed", _on_brick_destroyed)

func _on_brick_destroyed():
    print("Destroyed")
    brick_count -= 1
    if brick_count < 1:
        reset_level()

func reset_paddle():
    # Put the paddle and ball in the right place on the screen.
    paddle.position = Vector2(574, 569)
    ball.position = Vector2(574, 549)
    ball.velocity = Vector2(0, -ball_speed)
    
func _on_kill_zone_body_entered(body: Node2D) -> void:
    reset_paddle()
