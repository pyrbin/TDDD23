extends "../weapon.gd"

onready var projectile = preload("Projectile.tscn")
onready var projectile_pivot = $Pivot/Area2D/Sprite/Projectile_Pivot
onready var root_projs = get_tree().get_nodes_in_group("Root_Projs")[0]

var _current_proj = null

func _ready():
    wep_sprite.set_flip_v(false)
    hitbox.disabled = true

func _ammo_loaded():
    return projectile_pivot.get_child_count() > 0

func _setup():
    if not _ammo_loaded():
        _reload()

func _reload():
    if _ammo_loaded(): return
    _current_proj = null
    _current_proj = projectile.instance()
    _current_proj.connect("on_collision", self, "on_projectile_hit")
    projectile_pivot.add_child(_current_proj)
    _current_proj.sprite.set_texture(load(data.ammo))

func on_projectile_hit(co, projectile):
    if _current_proj == null: return;
    if is_hitable(co):
        _on_body_entered(co)
    projectile.stop()
    projectile = null

func _fire_ammo():
    if _current_proj == null: return;
    var pos = holder.get_aim_position()
    var angle = holder.global_position.angle_to_point(pos)
    var dir = Vector2(-cos(angle), -sin(angle))
    var proj_pos = _current_proj.get_node("Sprite").global_position
    projectile_pivot.remove_child(_current_proj)
    root_projs.add_child(_current_proj)
    _current_proj.collision_mask = $Pivot/Area2D.collision_mask
    _current_proj.position = proj_pos
    _current_proj.direction = dir
    _current_proj.look_at(pos)
    _current_proj.fire(data.attributes["ATTACK_SPEED"])

func is_ready():
    return .is_ready() && _ammo_loaded()

func _action_attack():
    _fire_ammo()
    _clear_attack()

func _on_cooldown_finished():
    _reload()