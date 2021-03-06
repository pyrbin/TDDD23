extends "../interactable.gd"

const Equippable = preload("res://data/equippable.gd")
const UNKNOWN_ICON_PATH = "res://assets/items/unknown_icon.png"
export (int) var item_id
onready var item_data = null

func _ready():
    set_item(item_id)
    anim_player.play("idle")
        
func get_action_string():
    if item_data == null: return
    return make_action_string("Pickup") + " [color=lightblue]" + item_data.name + "[/color] \n"

func set_item(item_id):
    var item = gb_ItemDatabase.get_item(item_id)
    if item == null:
        interactable = false
        set_visible(false)
        return
    self.item_id = item_id
    item_data = item
    set_visible(true)
    interactable = true
    if (sprite && anim_player):
        if item_data.slot == Equippable.SLOT.WEAPON:
            sprite.rotation = 100
        else:
            sprite.rotation = 0
        var icon = load(item_data.icon)
        sprite.set_texture(icon if icon != null else load(UNKNOWN_ICON_PATH))
        set_shader_color()

func interact():
    .interact()
    var item = gb_ItemDatabase.get_item(item_id)
    player.queue_interactable(self, false)
    player.add_item(item_id)
    visible = false
    set_shader_color()
    hide()
 #   yield(utils.timer(2), "timeout")
    queue_free()