extends CharacterBody2D

@onready var rect := $ColorRect
@onready var infected := false

@onready var rng := RandomNumberGenerator.new()

const CHANGE_DIRECTION_TIME = 1.20

@onready var living_color = Color(0,1,0)
@onready var zombie_color = Color(1,0,0)
@onready var change_direction_ago = 0
@onready var speed := 20;

signal new_infection(person)
# Called when the node enters the scene tree for the first time.
func _ready():
	rect.color = living_color
	change_direction()
		
func set_infected():
	new_infection.emit(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision := move_and_collide(velocity * speed * delta)
		
	if collision || hit_edge_of_screen():
		change_direction()
	
	if change_direction_ago > CHANGE_DIRECTION_TIME:
		change_direction()
	else:
		change_direction_ago += delta
		
func hit_edge_of_screen():
	var offscreen := false
	if position.x > 700 || position.x < 0:
		position.x = clamp(0, position.x, 700)
		offscreen = true
	if position.y > 600 || position.y < 0:
		position.y = clamp(0, position.y, 600)
		offscreen = true

	return offscreen
	
func change_direction():
	velocity = Vector2(randf_range(-0.2, 0.2), randf_range(-0.2, 0.2)).normalized()
	change_direction_ago = 0
