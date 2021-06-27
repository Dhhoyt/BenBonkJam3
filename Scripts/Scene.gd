extends Node2D
class_name Scene
signal change_scene(scene)
signal change_scene_with_transition(scene, transitionOut, transitionIn)
func change_scene(scene):
	emit_signal("change_scene", scene)
func change_scene_with_transition(scene, transitionOut, transitionIn):
	emit_signal("change_scene_with_transition", scene, transitionOut, transitionIn)
