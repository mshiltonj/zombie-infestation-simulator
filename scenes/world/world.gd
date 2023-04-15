extends Node2D

@onready var building_scene := preload("res://entities/building/building.tscn")
@onready var person_scene := preload("res://entities/person/person.tscn")
@onready var zombie_scene := preload("res://entities/zombie/zombie.tscn")
@onready var rng := RandomNumberGenerator.new()
@onready var alive_count_label := $HUD/AliveCount
@onready var zombie_count_label := $HUD/ZombieCount
@onready var time_count_label := $HUD/TimeCount
@onready var background := $background

const CITY_HEIGHT := 600
const CITY_WIDTH := 700
const POPULATION := 2500

@onready var alive_count := 0
@onready var zombie_count := 0
@onready var seconds := 0
@onready var timer = $Timer

@onready var background_color = Color(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	background.color = background_color
	timer.timeout.connect(tick)
	generate_map()
	
	
func tick():
	seconds += 1
	time_count_label.text = str(seconds)
		

func new_infection_handler(person):
	add_zombie(person.position)
	remove_child(person)
	person.queue_free()
	alive_count -= 1
	zombie_count += 1
	alive_count_label.text = str(alive_count)
	zombie_count_label.text = str(zombie_count)
	
func add_zombie(zombie_position):
	var zombie := zombie_scene.instantiate()
	zombie.position = zombie_position
	add_child(zombie)

func generate_map():
	timer.stop()
	var width := 0
	var height := 0
	var x_pos := 0
	var y_pos := 0
	
	var sizes := [25, 50, 75, 100]
	
	for i in 60:		
		width = sizes[randi() % sizes.size()]
		height = sizes[randi() % sizes.size()]
		x_pos = rng.randi_range(0, CITY_WIDTH-width) 
		x_pos = x_pos - (x_pos % 10) - 1
		y_pos = rng.randi_range(0, CITY_HEIGHT-height)
		y_pos = y_pos - (y_pos % 10) - 1 
		var building := building_scene.instantiate()
		building.position = Vector2(x_pos, y_pos)
		building.set_size(width, height)
		
		add_child(building)
	
	var point : Vector2
	var person
	
	if true:
		for i in POPULATION - 1:
			point = get_point_not_in_building()
			person = person_scene.instantiate()
			person.new_infection.connect(new_infection_handler)
			person.position = point
			add_child(person)
		
	point = get_point_not_in_building()
	add_zombie(point)
	
	alive_count = POPULATION - 1
	zombie_count = 1
	
	alive_count_label.text = str(alive_count) 
	zombie_count_label.text = str(zombie_count)	
	
	seconds = 0
	timer.start()
	

func get_point_not_in_building() -> Vector2:
	var point = Vector2(rng.randi_range(0, CITY_WIDTH-2), rng.randi_range(0, CITY_HEIGHT-2))
	
	while in_building(point):
		point = Vector2(rng.randi_range(0, CITY_WIDTH-2), rng.randi_range(0, CITY_HEIGHT-2))
		
	return point
	
func in_building(point) -> bool :
	#print("POINT X", point.x)
	#print("POINT Y", point.y)
	var colliding = false
	for n in get_tree().get_nodes_in_group('building'):
		#print("BOX X1 ", n.position.x)
		#print("BOX X2 ", n.position.x + n.width)
		#print("BOX Y1 ", n.position.y)
		#print("BOX Y2 ", n.position.y + n.height)
		if point.x >= n.position.x && point.x <= n.position.x + n.width && point.y >= n.position.y && point.y <= n.position.y + n.height: 
			colliding = true
			break
	return colliding
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed('restart'):
		restart()
	
func restart():
	time_count_label.text = ''
	for n in get_tree().get_nodes_in_group('building'):
		remove_child(n)
		n.free()
	for n in get_tree().get_nodes_in_group('people'):
		remove_child(n)
		n.free()
	for n in get_tree().get_nodes_in_group('zombies'):
		remove_child(n)
		n.free()
	generate_map()

			


func _on_restart_pressed():
	Sfx.play('click')
	restart()
