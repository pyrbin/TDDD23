extends HBoxContainer

onready var life_bar = $StatusBars/LifeBar/TextureProgress
onready var life_text = $StatusBars/LifeBar/TextureProgress/Label
onready var energy_bar = $StatusBars/MarginContainer/EnergyBar/TextureProgress
onready var energy_text = $StatusBars/MarginContainer/EnergyBar/TextureProgress/Label
onready var controller = $MarginContainer/ItemSlotContainer

var player
var status
var other_controller

func _ready():
    player = get_tree().get_nodes_in_group("Player")[0]
    #other_controller = get_tree().get_nodes_in_group("Equipment_ItemContainer")[0]
    if not player.action_equipment:
        player.connect("player_loaded", self, "_on_player_loaded")
    else:
        _on_player_loaded()
    
func _on_player_loaded():
    controller.connect_to_item_container(player.action_equipment, player, ["M1", "Q"])
    status = player.status
    player.connect("used_special", self, "_on_used_special")

func _on_used_special(special):
    controller.set_cooldown(special.cooldown)

func _process(delta):
    if status:
        life_text.set_text(String(int(status.health)) + "/" + String(int(status.get_max_health())))
        life_bar.value = (status.health/status.get_max_health())
        energy_bar.value = float(status.endurance)/status.get_max_endurance()
        energy_text.set_text(String(status.endurance) + "/" + String(status.get_max_endurance()))
