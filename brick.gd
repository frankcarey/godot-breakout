@tool
extends StaticBody2D
class_name Brick

@onready var shape: RectangleShape2D = $CollisionShape2D.shape
@export var hits_remaining: int = 1
@export var color: Color = Color.CADET_BLUE
@export var size: Vector2 = Vector2.ZERO :
    get:
        return size
    set(value):
        size = value
        if shape:
            shape.size = value
            
            
            
signal BrickDestroyed()

func hit():
    hits_remaining -= 1
    if hits_remaining < 1:
        BrickDestroyed.emit()
        queue_free()
        
func _ready() -> void:
    if shape:
        shape.size = size
    
func _draw() -> void:
    const thickness = 5
    var position = Vector2.ZERO - shape.size / 2.
    draw_rect(Rect2(position, shape.size), color)
    var highlight_color = color.lightened(0.2)
    var shadow_color = color.darkened(0.2)
    var offset = thickness / 2.
    draw_rect(Rect2(position, shape.size), color)
    
    var pos = position
    draw_line(pos + Vector2(0, offset), pos + Vector2(shape.size.x, offset), highlight_color, thickness)
    draw_line(pos + Vector2(offset, 0), pos + Vector2(offset, shape.size.y), highlight_color, thickness)
    pos = position + shape.size
    draw_line(pos - Vector2(0, offset), pos - Vector2(shape.size.x, offset), shadow_color, thickness)
    draw_line(pos - Vector2(offset, 0), pos - Vector2(offset, shape.size.y), shadow_color, thickness)
