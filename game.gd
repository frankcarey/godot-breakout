extends Node

@onready var paddle = $Paddle
@onready var ball = $Ball
@onready var killZone = $"Field/KillZone"

const paddle_speed = 300.0
const ball_speed = 300.0

func _ready() -> void:
    start_game()

func start_game():
    # Put the paddle and ball in the right place on the screen.
    paddle.position = Vector2(574, 569)
    ball.position = Vector2(574, 549)
    ball.velocity = Vector2(0, -ball_speed)
     
    
