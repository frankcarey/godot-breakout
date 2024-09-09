extends CharacterBody2D
class_name Paddle

const SPEED = 300.0
@onready var shape = $CollisionShape2D.shape

## The paddle's width based on the shape's size
## in the x direction.
func get_paddle_width():
    return shape.size.x

func _physics_process(delta: float) -> void:

    # Move the paddle based on input.
    var direction := Input.get_axis("ui_left", "ui_right")
    move_and_collide(Vector2(direction * SPEED * delta, 0))
