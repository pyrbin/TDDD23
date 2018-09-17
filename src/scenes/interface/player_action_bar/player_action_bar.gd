extends HBoxContainer

var player
var other_controller

func _ready():
    player = get_tree().get_nodes_in_group("Player")[0]
    other_controller = get_tree().get_nodes_in_group("Equipment_ItemContainer")[0]
    if not player.action_equipment:
        player.connect("player_loaded", self, "_on_player_loaded")
    else:
        _on_player_loaded()
    
func _on_player_loaded():
    $MarginContainer/ItemSlotContainer.connect_to_item_container(player.action_equipment, player, ["M1", "Q"])
    #$MarginContainer/ItemSlotContainer.connect_controller(other_controller)


