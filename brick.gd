@tool
extends StaticBody2D
class_name Brick

@onready var shape: RectangleShape2D = $CollisionShape2D.shape

## Number of hits this block requires to be destroyed.
@export var hits_remaining: int = 1
## The color of this block.
@export var color: Color = Color.CADET_BLUE
## The size of this block (width and height)
@export var size: Vector2 = Vector2.ZERO :
    get:
        return size
    set(value):
        size = value
        if shape:
            shape.size = value
            
            
## A Signal to notify any subscriber that a brick was destroyed.           
signal BrickDestroyed()

## A callback that should be called whenever this brick is hit.
## Allows the "Ball" to call it for instance when it connects.
func hit():
    # Every hit, lower by one until destroyed.
    hits_remaining -= 1
    if hits_remaining < 1:
        # Trigger signal that this brick was destroyed.
        BrickDestroyed.emit()
        # Destroy this brick.
        queue_free()
        
func _ready() -> void:
    if shape:
        shape.size = size
## This is an example of drawing the blocks directly using the
## built-in _draw() function. This @tool makes it easier for game designers
## to just set a color and size and not worry about the collider shape. 
func _draw() -> void:
    # First, draw a box representing the block.
    const thickness = 5
    var position = Vector2.ZERO - shape.size / 2.
    draw_rect(Rect2(position, shape.size), color)
    
    # Now draw the highlights and shadows as lines
    var highlight_color = color.lightened(0.2)
    var shadow_color = color.darkened(0.2)
    var offset = thickness / 2.
    var pos = position
    draw_line(pos + Vector2(0, offset), pos + Vector2(shape.size.x, offset), highlight_color, thickness)
    draw_line(pos + Vector2(offset, 0), pos + Vector2(offset, shape.size.y), highlight_color, thickness)
    pos = position + shape.size
    draw_line(pos - Vector2(0, offset), pos - Vector2(shape.size.x, offset), shadow_color, thickness)
    draw_line(pos - Vector2(offset, 0), pos - Vector2(offset, shape.size.y), shadow_color, thickness)
