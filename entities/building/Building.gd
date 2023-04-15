extends Node2D

@export var width := 100
@export var height := 100

@onready var rect := $ColorRect
@onready var collision_shape := $CollisionShape2D
@onready var building_color = Color(50/255.0, 50/255.0, 80/255.0)
#@onready var building_color = Color(107,107,135)

# Called when the node enters the scene tree for the first time.
func _ready():
	rect.size = Vector2(width, height)
	rect.color = building_color
	collision_shape.shape.size = Vector2(width, height)
	collision_shape.position.x = width / 2.0
	collision_shape.position.y = height / 2.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#rect.size = Vector2(width, height)
	pass
	
func set_size(new_width, new_height):
	self.width = new_width
	self.height = new_height
