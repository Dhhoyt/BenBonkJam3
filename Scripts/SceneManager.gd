extends Node2D
var oldScene
var newScenePath
var outTransition
var inTransition
func _ready():
	oldScene = $Scenes.get_children()[0]
	connect_scene()
	$Transition/AnimationPlayer.play("Gone")
func change_scene(scene):
	change_scene_with_transition(scene, "In", "Out")
func change_scene_with_transition(scene, transitionOut, transitionIn):
	newScenePath = load(scene)
	outTransition = transitionOut
	inTransition = transitionIn
	$Transition/AnimationPlayer.play(transitionOut)
	if !$Transition/AnimationPlayer.is_connected("animation_finished", self, "on_transition_end"):
		$Transition/AnimationPlayer.connect("animation_finished", self, "on_transition_end")
func on_transition_end(anim):
	$Transition/AnimationPlayer.disconnect("animation_finished", self, "on_transition_end")
	var newScene = newScenePath.instance()
	$Scenes.remove_child(oldScene)
	$Scenes.add_child(newScene)
	oldScene.queue_free()
	oldScene = newScene
	connect_scene()
	$Transition/AnimationPlayer.play(inTransition)
func connect_scene():
	oldScene.connect("change_scene", self, "change_scene")
	oldScene.connect("change_scene_with_transition", self, "change_scene_with_transition")
