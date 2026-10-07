extends CharacterBody2D

@onready var left_thread: Line2D = $Left_thread
@onready var right_thread: Line2D = $Right_thread

@onready var left_area: Area2D = $Left_area
@onready var right_area: Area2D = $Right_area

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const speed = 600.0
const jump_force = 1600.0

const acceleration=100
const jump_acelerate=400
var gravity=1

var last_rotation

var can_fall=true

var direction=Vector2i.ZERO

var normal_velocity=Vector2.ZERO

func _ready() -> void:
	last_rotation=rotation
func _physics_process(delta: float) -> void:
	direction.x = Input.get_axis("Left", "Right")
	
	normal_velocity.y += (gravity*delta)
	
	velocity=normal_velocity.rotated(last_rotation-rotation)


	if direction.x:
		animated_sprite_2d.scale.x=abs(animated_sprite_2d.scale.x)*direction.x
	
	left_area.position=left_thread.get_point_position(1)
	right_area.position=right_thread.get_point_position(1)
	
	move_and_slide()
