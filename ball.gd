
extends CharacterBody2D

@onready var shape: CircleShape2D = $"CollisionShape2D".shape

## Override _draw() to visualize the ball.
func _draw() -> void:
    # This draws a filled in circle.
    draw_circle(Vector2.ZERO, shape.radius, Color.WHITE)

func _physics_process(delta: float) -> void:
    # Move the ball along the current velocity and check for collisions.
    var collision_info = move_and_collide(velocity * delta)
    
    # Check if the ball collided this (physics) frame.
    if collision_info:
        
        # First, bounce as normal.
        velocity = velocity.bounce(collision_info.get_normal())
        
        # Then, check if ball collided with a paddle so we can offset the velocity
        # based on where along the paddle it collided.
        var collider: CollisionObject2D = collision_info.get_collider()
        if collider.is_in_group("Paddle"):
            
            # We collided with a paddle, so just change the name for readability.
            var paddle: Paddle = collider
            
            # Offset the velocity based on where along the paddle it impacted.
            # Note: This calls the custom get_width() function on paddle.gd
            var width = paddle.get_paddle_width()
            var offset = (position.x - paddle.position.x) / width
            velocity.x += offset * 100.0  # Adds an offset based on the hit location to create angled bounces

            # Normalize the velocity vector to keep the ball speed constant
            velocity = velocity.normalized() * 300  # Ensuring constant speed after bounce
    

    
    
    
    
