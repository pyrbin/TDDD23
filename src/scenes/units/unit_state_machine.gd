extends "res://scenes/common/state_machine.gd"

func _ready():
    states_map = {
        "idle": $Idle,
        "move": $Move,
        "jump": $Jump,
        "dead": $Dead,
        "stagger": $Stagger
    }
    owner.get_node("AnimationPlayer").connect("animation_finished", self, "_on_animation_finished")

func _change_state(state_name):
    if not _active:
        return
    # if state_name in ["stagger", "jump"]:
    #     states_stack.push_front(states_map[state_name])
    if states_map.has(state_name):
        ._change_state(state_name)
