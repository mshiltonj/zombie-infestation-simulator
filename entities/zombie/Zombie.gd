extends CharacterBody2D

const CHANGE_DIRECTION_TIME = 1.20

@onready var rect := $ColorRect
@onready var rng := RandomNumberGenerator.new()
@onready var change_direction_ago = 0
@onready var speed = 45
@onready var energy_timer = $EnergyTimer

func _ready():
	change_direction()
	energy_timer.timeout.connect(func(): self.speed *= 0.91 )

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision := move_and_collide(velocity * delta * speed)
	if collision || hit_edge_of_screen():
		change_direction()
		
	if collision && collision.get_collider().is_in_group('people'):
		self.speed = 45
		collision.get_collider().set_infected()
		
	if change_direction_ago > CHANGE_DIRECTION_TIME:
		change_direction()
	else:
		change_direction_ago += delta

func change_direction():
	velocity = Vector2(randf_range(-0.2, 0.2), randf_range(-0.2, 0.2)).normalized()
	change_direction_ago = 0
		
func hit_edge_of_screen():
	var offscreen := false
	if position.x > 700 || position.x < 0:
		position.x = clamp(0, position.x, 700)
		offscreen = true
	if position.y > 600 || position.y < 0:
		position.y = clamp(0, position.y, 600)
		offscreen = true

	return offscreen
