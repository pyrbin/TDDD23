extends Control
export (bool) var disabled = false
onready var marker = $Marker
onready var tween = $Tween
var player

func _ready():
    hide()
    player = get_tree().get_nodes_in_group("Player")[0]
    player.connect("attacking", self, "_on_player_attack")
    tween.connect("tween_completed", self, "_on_indicator_complete")

func _on_player_attack():
    if disabled: return
    if !player.weapon: return
    if not player.has_ranged_wep(): 
        hide()
        return
    var speed = player.weapon.data.cooldown
    play_cooldown_indicator(speed)

func play_cooldown_indicator(speed):
    if disabled: return
    show()
    tween.interpolate_property(marker, "rect_position", Vector2(0, -2), Vector2(39,-2), speed,
        Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    tween.start()

func _on_indicator_complete(obj, path):
    hide()