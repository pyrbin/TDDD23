extends "../interactable.gd"

export (Texture) var texture
export (Array, int) var container_items = []
export (bool) var idle_jump = true
export (bool) var remove_on_use = true

onready var container = null
var open_container = false

const MAX_DISTANCE = 140

func _ready():
    init(container_items)

func init(p_container_items):
    container = load("res://scripts/item_container/item_container.gd").new()
    var slots = []
    slots.resize(p_container_items.size())
    for i in range(0, p_container_items.size()):
        slots[i] = 0
    container.init(slots, p_container_items)
    container.connect("value_changed", self, "_on_loot_change")
    sprite.set_texture(texture)
    if idle_jump:
        anim_player.play("idle")
    else:
        anim_player.stop()

func get_action_string():
    return make_action_string("Open") + " [color=lightblue]" + interactable_name + "[/color] \n"

# TODO: this function is not DRY, repeated in "scenes/interactable/lootable/lootable.gd"
func drop_item(index, item_container = container, offset = Vector2(0, -10)):
    var item = container.get(index)
    container.delete(index)
    if item == null: return
    var instance = load("res://scenes/interactable/item/Item.tscn").instance()
    get_tree().get_nodes_in_group("Root_Items")[0].add_child(instance)
    instance.set_item(item)
    instance.position = global_position + offset

func set_inventory(array):
    for d in range(0, len(array)):
        container.set(d, array[d])

func interact():
    .interact()
    var c = 0
    for i in range(0, container.size()):
        if container.get(i) == null: continue
        drop_item(i, container, Vector2(-60 + (c * 36), 15))
        c+=1
    interactable = false
    anim_player.play("open")
    player.queue_interactable(self, false)
    $CollisionShape2D.disabled = true
    if remove_on_use:
        queue_free()

func _on_loot_change(slot):
    pass

