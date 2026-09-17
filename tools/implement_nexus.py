from pathlib import Path
import json

def edit(path, old, new):
    p = Path(path)
    s = p.read_text(encoding='utf-8')
    assert old in s, (path, old[:100])
    p.write_text(s.replace(old, new), encoding='utf-8')

p = Path('data/estate_layout.json')
data = json.loads(p.read_text(encoding='utf-8'))
n = data['nexus']
n['width'] = 4200
n['rooms'][0]['end'] = 4200
n['enemy'] = 3000
n['light_regions'] = [[450,750],[1950,2250],[3450,3750]]
n['surface_regions'] = [[900,1800,'RUBBLE'],[2400,3300,'RUBBLE']]
n['patrol_points'] = [[300,490],[600,540],[1350,575],[2100,540],[2850,575],[3600,540],[3900,490],[2850,410],[2100,590],[1350,410]]
n['props'] = [p for p in n['props'] if p[1] != 'nexus_bell']
positions = {'LN-A':600,'LN-B':2100,'LN-C':3600,'nexus_hide_west':1350,'nexus_hide_east':2850,'ln_center_charge_1':2100}
for prop in n['props']:
    if prop[1] in positions: prop[2] = positions[prop[1]]
    if prop[1] in ['LN-A','LN-B','LN-C']:
        choice = {'LN-A':'destroy','LN-B':'flee','LN-C':'remain'}[prop[1]]
        prop[4].update(display_name=choice.capitalize() + (' - awaken rune' if choice == 'destroy' else ' - Hold E for 20s'), ending_type=choice)
n['props'] += [
 ['item_pickup','nexus_knife',900,500,{'display_name':'Knife','item_id':'knife','action_animation_override':'bag_pickup'}],
 ['letter_pickup','nexus_guide',1650,500,{'display_name':'Guide Letter','title':'The Last Keeper — Guide Letter','action_animation_override':'bag_pickup'}],
 ['item_pickup','nexus_power',3900,500,{'display_name':'The Power','item_id':'power','required_flag':'nexus_guide_read','action_animation_override':'bag_pickup'}],
 ['lore','nexus_trap',0,500,{'display_name':'Set trap + drop The Power'}],
 ['exit_door','nexus_ending_door',2220,430,{'display_name':'Cross the final threshold','ending_type':'destroy'}]
]
# Use the existing generic item/exit scene presets.
scenes = {x.stem for x in Path('scenes/interactables').glob('*.tscn')}
for prop in n['props']:
    if prop[0] not in scenes:
        prop[0] = 'base_interactable'
        prop[4]['kind'] = 'exit' if prop[1] == 'nexus_ending_door' else 'item'
p.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
p = Path('data/estate_art.json')
data = json.loads(p.read_text(encoding='utf-8'))
n = data['zones']['nexus']
n['surfaces'][0][1] = 4200
n['plain_tables'] = []
n['passage_labels']['nexus_ending_door'] = 'Cross the final threshold'
n['decorations'] = [['ritual_stone',600,340,180],['ritual_stone',2100,340,230],['ritual_stone',3600,340,180]] + [['cat_rubble',x,405,120] for x in [1050,1550,2550,3100]]
p.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
edit('scenes/levels/nexus_floor.tscn','res://scripts/levels/estate_room.gd','res://scripts/levels/nexus_room.gd')
edit('scripts/player/room_camera.gd','\t\ttarget = Vector2(900, room_center_y)\n\t\tzoom = Vector2.ONE * minf(1.0, get_viewport_rect().size.x / 1500.0)','\t\t# Keep the visible span below rune spacing, including ultrawide windows.\n\t\tzoom = Vector2.ONE * maxf(1.0, get_viewport_rect().size.x / 1280.0)')
edit('scripts/levels/estate_room.gd','var ward_seconds := 0.0\n','')
edit('scripts/levels/estate_room.gd','func patrol_target(stage: int, index: int) -> Vector2:\n','func patrol_target(stage: int, index: int) -> Vector2:\n\tif zone_id == "nexus":\n\t\tvar points: Array = layout.patrol_points\n\t\tvar point: Array = points[index % points.size()]\n\t\treturn clamp_point(Vector2(point[0], point[1]))\n')
edit('scripts/levels/estate_room.gd','\tif GameManager.state == GameManager.State.PLAYING:\n\t\tward_seconds = maxf(0.0, ward_seconds - delta)\n','')
p=Path('scripts/levels/estate_room.gd'); s=p.read_text(); a=s.index('func ring_ward_bell()'); b=s.index('func _story_once',a); p.write_text(s[:a]+s[b:],encoding='utf-8')
edit('scripts/levels/estate_room.gd','Rect2(260, 365, 1280, 250)','Rect2(260, 365, room_width - 520, 250)')

edit('scripts/interactables/base_interactable.gd','\tif interaction_id in ["nexus_bell", "echo_supply_cache"]:', '''\tif interaction_id == "nexus_ending_door":
\t\treturn not str(FreedomLedger.flags.get("nexus_outcome", "")).is_empty()
\tif interaction_id == "nexus_trap":
\t\tvar enemy = get_tree().get_first_node_in_group("enemy")
\t\treturn enemy != null and enemy.blood_trap_seconds > 0.0 and str(FreedomLedger.flags.get("nexus_outcome", "")).is_empty()
\tif kind == "anchor" and GameManager.zone == "nexus" and not str(FreedomLedger.flags.get("nexus_outcome", "")).is_empty():
\t\treturn false
\tif kind == "item" and not FreedomLedger.has_requirement(required_flag):
\t\treturn false
\tif interaction_id == "echo_supply_cache":''')
edit('scripts/interactables/base_interactable.gd','func refresh() -> void:\n','func refresh() -> void:\n\tif interaction_id in ["nexus_ending_door", "nexus_trap"]:\n\t\tvisible = available()\n\t\treturn\n')
edit('scripts/interactables/base_interactable.gd','\tif not interaction_id.is_empty() and not CollectibleManager.is_currently_active', '\tif interaction_id != "nexus_guide" and not interaction_id.is_empty() and not CollectibleManager.is_currently_active')
edit('scripts/interactables/base_interactable.gd','\t\tCollectibleManager.advance()','\t\tif interaction_id == "nexus_guide":\n\t\t\tget_tree().get_first_node_in_group("room").read_guide()\n\t\telse:\n\t\t\tCollectibleManager.advance()')
p=Path('scripts/interactables/base_interactable.gd');s=p.read_text();a=s.index('\tif interaction_id == "nexus_bell":');b=s.index('\tif interaction_id == "echo_supply_cache":',a);s=s[:a]+'''\tif interaction_id == "nexus_trap":
\t\tvar player = get_tree().get_first_node_in_group("player")
\t\tif not get_tree().get_first_node_in_group("room").place_power(player):
\t\t\tsay("Carry the Knife and The Power, and read the Guide Letter first.")
\t\treturn
'''+s[b:];p.write_text(s,encoding='utf-8')
edit('scripts/interactables/base_interactable.gd','func _channel_anchor(player: Node2D) -> void:\n','''func _channel_anchor(player: Node2D) -> void:
\tvar room = get_tree().get_first_node_in_group("room")
\tif GameManager.zone == "nexus":
\t\troom.trigger_alarm()
\t\tif ending_type == "destroy":
\t\t\tsay("Find the Knife and Guide Letter. Take The Power, then Y to trap the Hound; E at the trap to finish it.", 5.0)
\t\t\treturn
''')
edit('scripts/interactables/base_interactable.gd','\tvar started_serial := interrupt_serial\n\tvar elapsed := 0.0\n\twhile elapsed < channel_seconds:', '\tvar started_serial := interrupt_serial\n\tvar start_position := player.global_position\n\tvar epoch := GameManager.transition_epoch\n\tvar elapsed := 0.0\n\twhile elapsed < channel_seconds:')
edit('scripts/interactables/base_interactable.gd','\t\tif interrupt_serial != started_serial or _player_is_detected() or GameManager.state != GameManager.State.PLAYING:', '\t\tif not is_instance_valid(player) or epoch != GameManager.transition_epoch:\n\t\t\treturn\n\t\tif interrupt_serial != started_serial or _player_is_detected() or player.global_position.distance_to(start_position) > 3.0 or GameManager.state != GameManager.State.PLAYING:')
edit('scripts/interactables/base_interactable.gd','\tsay("Anchor cleansed.")\n\tif ending_type in ["severance", "custodian_rest", "vessel"]:\n\t\tEventBus.ending_triggered.emit(ending_type)','\tif GameManager.zone == "nexus":\n\t\troom.complete_outcome(ending_type, global_position)')
edit('scripts/core/freedom_ledger.gd','\t\t"severance", "custodian_rest", "vessel":\n\t\t\treturn current_part == 2 and anchors_cleansed.size() >= 1','\t\t"destroy", "flee", "remain":\n\t\t\treturn current_part == 2 and flags.get("nexus_outcome", "") == candidate')
edit('scripts/core/game_manager.gd','\tif kind == "loop":','\tif kind in ["loop", "remain"]:')

edit('scripts/enemy/deprived_one.gd','\tWANDER_BLIND,','\tNEXUS_ROAM,\n\tWANDER_BLIND,')
edit('scripts/enemy/deprived_one.gd','var state: State = State.WANDER_BLIND','var nexus_hunting := false\nvar blood_trap_seconds := 0.0\nvar nexus_defeated := false\nvar state: State = State.WANDER_BLIND')
edit('scripts/enemy/deprived_one.gd','func _patrol_state() -> State:\n','func _patrol_state() -> State:\n\tif is_instance_valid(room) and room.zone_id == "nexus":\n\t\treturn State.NEXUS_ROAM\n')
edit('scripts/enemy/deprived_one.gd','\tstate = next\n','\tstate = next\n\tif state == State.NEXUS_ROAM:\n\t\tdetection_active = false\n\t\t_choose_patrol_target()\n')
edit('scripts/enemy/deprived_one.gd','func _physics_process(delta: float) -> void:\n','func _physics_process(delta: float) -> void:\n\tif nexus_defeated:\n\t\treturn\n')
edit('scripts/enemy/deprived_one.gd','\thearing_time += delta','\tblood_trap_seconds = maxf(0.0, blood_trap_seconds - delta)\n\thearing_time += delta')
edit('scripts/enemy/deprived_one.gd','\t_update_state(delta)\n','''\t_update_state(delta)
\t# The alarm maintains a trail, but only the existing senses confirm detection.
\t# Hiding and distractions buy time; a lost trail returns to arena patrol.
\tif nexus_hunting and not is_distracted and player.hidden_spot == null:
\t\ttarget = player.global_position
\t\tlast_seen = target
\t\tif state != State.CHASE and state != State.HUNT_AUDIO:
\t\t\tchange_state(State.HUNT_AUDIO)
''')
edit('scripts/enemy/deprived_one.gd','\t\tState.PATROL_AUDIO, State.PATROL_SIGHT:', '\t\tState.NEXUS_ROAM, State.PATROL_AUDIO, State.PATROL_SIGHT:')
edit('scripts/enemy/deprived_one.gd','\t\t\tif _stage() >= 3 and ambush_clock <= 0.0:', '\t\t\tif state != State.NEXUS_ROAM and _stage() >= 3 and ambush_clock <= 0.0:')
edit('scripts/enemy/deprived_one.gd','func stun(seconds: float) -> void:', '''func begin_nexus_hunt() -> void:
\tnexus_hunting = true
\tis_distracted = false
\tdistraction_arrived = false
\tdistraction_stay_timer = 0.0
\tif is_instance_valid(player):
\t\ttarget = player.global_position
\t\tlast_seen = target
\tchange_state(State.HUNT_AUDIO)

func bind_blood_trap() -> void:
\tstun(18.0)
\tblood_trap_seconds = 18.0

func defeat_in_nexus() -> void:
\tstun(3600.0)
\tnexus_defeated = true
\tblood_trap_seconds = 0.0
\tcollision_layer = 0
\tcollision_mask = 0
\tvar fade := create_tween()
\tfade.tween_property(self, "modulate:a", 0.0, 1.0)

func stun(seconds: float) -> void:''')
edit('scripts/player/player.gd','var stun_cooldown: float = 0.0','var stun_cooldown: float = 0.0\nvar blood_trap_cooldown := 0.0')
edit('scripts/player/player.gd','\tstun_cooldown = maxf(0.0, stun_cooldown - delta)','\tstun_cooldown = maxf(0.0, stun_cooldown - delta)\n\tblood_trap_cooldown = maxf(0.0, blood_trap_cooldown - delta)')
edit('scripts/player/player.gd','\tif Input.is_action_just_pressed("stun"):', '\tif Input.is_action_just_pressed("blood_trap"):\n\t\tuse_blood_trap()\n\tif Input.is_action_just_pressed("stun"):')
edit('scripts/player/player.gd','\tvar gadget := "bottle"', '''\tif int(FreedomLedger.inventory.get("power", 0)) > 0:
\t\tvar room = get_tree().get_first_node_in_group("room")
\t\tif GameManager.zone == "nexus" and room != null and room.place_power(self):
\t\t\tEventBus.ability_used.emit("power")
\t\t\treturn true
\t\t_ability_feedback("The Power needs the Knife and a bound Hound. Approach the Blood Trap.")
\t\treturn false
\tvar gadget := "bottle"''')
edit('scripts/player/player.gd','func use_stun() -> bool:', '''func use_blood_trap() -> bool:
\tif GameManager.state != GameManager.State.PLAYING or GameManager.zone != "nexus" or not FreedomLedger.flags.get("nexus_guide_read", false):
\t\t_ability_feedback("Find and read the Guide Letter in the Nexus first.")
\t\treturn false
\tif blood_trap_cooldown > 0.0 or FreedomLedger.hp <= 40.0 or not str(FreedomLedger.flags.get("nexus_outcome", "")).is_empty():
\t\t_ability_feedback("Blood Trap needs more than 40 HP and a ready cooldown.")
\t\treturn false
\tvar enemy = get_tree().get_first_node_in_group("enemy")
\tif enemy == null or enemy.nexus_defeated or enemy.blood_trap_seconds > 0.0 or global_position.distance_to(enemy.global_position) > 192.0:
\t\t_ability_feedback("Bring the Hound within the Blood Trap's reach (192px).")
\t\treturn false
\tvar ray := PhysicsRayQueryParameters2D.create(global_position, enemy.global_position, 1)
\tif not get_world_2d().direct_space_state.intersect_ray(ray).is_empty():
\t\t_ability_feedback("Stone blocks the trap. Find a clear line to the Hound.")
\t\treturn false
\tget_tree().get_first_node_in_group("room").trigger_alarm()
\tFreedomLedger.damage(40.0)
\tblood_trap_cooldown = 60.0
\tenemy.bind_blood_trap()
\tvar effect := SigilField.new()
\teffect.radius = 192.0
\teffect.lifetime = 18.0
\teffect.tint = Color(0.85, 0.06, 0.08, 0.85)
\tget_parent().add_child(effect)
\teffect.global_position = enemy.global_position
\tplay_action("channel", 0.65, true)
\tEventBus.ability_used.emit("blood_trap")
\treturn true

func use_stun() -> bool:''')
edit('project.godot','[input]\n','''[input]

blood_trap={
"deadzone": 0.2,
"events": [Object(InputEventKey,"physical_keycode":89)]
}
''')

edit('scripts/levels/estate_art.gd','"LN-A": "SEVERANCE\\nDestroy entity and bond", "LN-B": "CUSTODIAN\'S REST\\nEls takes the burden", "LN-C": "VESSEL\\nTransfer the prison"','"LN-A": "DESTROY\\nKnife, Power and Blood Trap", "LN-B": "FLEE\\nHold E for 20 seconds", "LN-C": "REMAIN\\nHold E to begin again"')
edit('scripts/levels/estate_art.gd','\t\t\telif child.interaction_id == "nexus_bell":\n\t\t\t\t_service_marker(child, "WARD BELL\\nBind the Hound for 32s", Color("eac775"), -105.0)\n','')
edit('scripts/levels/estate_art.gd','\t\t\tif child.kind == "recharge":','\t\t\tchild.refresh()\n\t\t\tif child.kind == "recharge":')

edit('scripts/systems/field_guide.gd','\t\tif room != null and room.ward_seconds > 0.0:\n\t\t\treturn "Ward: %ds remaining | Choose ONE anchor and hold E for 20s" % ceili(room.ward_seconds)\n\t\treturn "Ring the Ward Bell to bind the Hound, then choose ONE ending. [H] Guide"','\t\tif room != null and not room.outcome.is_empty():\n\t\t\treturn "The door is open. Press E at the threshold."\n\t\treturn "Destroy: Knife + Guide + Power | Flee / Remain: hold E 20s. [H] Guide"')
edit('scripts/systems/field_guide.gd','static func ability_status(player: Node) -> String:\n','''static func ability_status(player: Node) -> String:
\tif GameManager.zone == "nexus":
\t\tvar enemy = player.get_tree().get_first_node_in_group("enemy")
\t\tvar held := " | Bound: %ds / 18s" % ceili(enemy.blood_trap_seconds) if enemy != null and enemy.blood_trap_seconds > 0.0 else ""
\t\tvar ready := "read Guide" if not FreedomLedger.flags.get("nexus_guide_read", false) else ("%ds" % ceili(player.blood_trap_cooldown) if player.blood_trap_cooldown > 0.0 else ("low HP" if FreedomLedger.hp <= 40.0 else "ready"))
\t\treturn "[Y] Blood Trap: %s / 40 HP%s | Knife %d / Power %d" % [ready, held, FreedomLedger.inventory.get("knife", 0), FreedomLedger.inventory.get("power", 0)]
''')
p=Path('scripts/systems/field_guide.gd');s=p.read_text();a=s.index('\tbody += "CONVERGENCE');b=s.index('\n\treturn body',a);s=s[:a]+'''\tbody += "CONVERGENCE — DESTROY, FLEE OR REMAIN\\nThe Hound roams the whole chamber. Touching any rune with E raises a red alarm and gives it your trail for this visit. Screens and rubble routes buy time.\\n\\n" + preload("res://scripts/levels/nexus_room.gd").GUIDE + "\\n\\nY is available on every branch after reading the Guide Letter. Blood Trap costs 40 HP flat, holds for 18 seconds, and has a 60-second cooldown; failed casts spend nothing. Q priority: battery below 56% charge, The Power, bottle, clock. Cyan stations restore HP; flashlight charge still needs batteries."
'''+s[b:];p.write_text(s,encoding='utf-8')
edit('scripts/ui/game_hud.gd','\tvar threat_edge := 0.0','\tvar threat_edge := 0.0\n\tif room != null and room.zone_id == "nexus" and room.alarm_seconds > 0.0:\n\t\tpulse.color = Color(0.9, 0.015, 0.02, 0.12 + 0.18 * (0.5 + 0.5 * sin(room.alarm_seconds * 9.0)))')
edit('scripts/ui/letter_reader.gd','\tinventory_summary.text = "Letters collected: %d\\n%s" % [FreedomLedger.letter_ids.size(), FreedomLedger.freedom_summary()]','\tinventory_summary.text = "Letters collected: %d | Knife: %d | The Power: %d\\n%s" % [FreedomLedger.letter_ids.size(), FreedomLedger.inventory.get("knife", 0), FreedomLedger.inventory.get("power", 0), FreedomLedger.freedom_summary()]')
