extends CanvasLayer

func _on_start_simulation_pressed():
	Sfx.play('click')
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")


func _on_start_simulation_mouse_entered():
	print('hover')
	Sfx.play('hover')
