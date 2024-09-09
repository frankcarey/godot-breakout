extends Node

@onready var paddle = $Paddle
@onready var ball = $Ball
@onready var killZone = $"Field/KillZone"
@onready var bricks = $Bricks

## Initial paddle speed on restart.
@export var paddle_speed = 300.0
## Initial ball speed on restart.
@export var ball_speed = 300.0

## The number of bricks remaining in this level.
var brick_count
## The current level the player is on.
var current_level = 1

## Allow designers to add levels by dropping scene files into the Inspector
@export var levels: Array[PackedScene]

func _ready() -> void:
    reset_level()
    reset_paddle()

## Forces the level to reset, basically reloading the blocks for
## the given level.
## 
## level: [optional] the level that should be loaded, starting with "1".
##      If no level is provided, it defaults to the current level.
func reset_level(level: int = 0):
    # If level not given, assume reloading the current level.
    if level:
        if level > levels.size():
            #TODO: Game is completed. For now, start over.
            current_level = 1
        else:
            current_level = level
    # Get the level out of the array (filled via "Game" Node in editor).
    var level_resource: PackedScene = levels[current_level - 1]
    # Instantiate the level (make it into a real Node)
    var lv = level_resource.instantiate()
    # Delete the old set of bricks just in case.
    bricks.queue_free()
    # Add the new level as a child to the "Game" node.
    add_child(lv)
    bricks = lv
    
    # Count up all the bricks in the new level.
    brick_count = bricks.get_child_count()
    # Subscribe to the "BrickDestroyed" signal, so we can count down the
    # remaining bricks.
    for brick in bricks.get_children():
        brick.connect(&"BrickDestroyed", _on_brick_destroyed)

## Capture the BrickDestroyed Signal and count down to know when to reset
## the level (or progress).
func _on_brick_destroyed():
    print("Destroyed")
    brick_count -= 1
    if brick_count < 1:
        # Load the next level.
        reset_level(current_level + 1)

## Reset the paddle to the middle of the screen and start the ball over again.
func reset_paddle():
    # Put the paddle and ball in the right place on the screen.
    #TODO: Make these based on screensize.
    paddle.position = Vector2(574, 569)
    paddle.speed = paddle_speed
    ball.position = Vector2(574, 549)
    ball.velocity = Vector2(0, -ball_speed)

## When the ball enters the killzone, reset the paddle.
func _on_kill_zone_body_entered(body: Node2D) -> void:
    reset_paddle()
