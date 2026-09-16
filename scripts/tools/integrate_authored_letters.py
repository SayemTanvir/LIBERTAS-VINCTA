"""Integrate the approved Section 5 bodies without changing IDs or coordinates."""
import json
import re
from pathlib import Path

root = Path(__file__).resolve().parents[2]
bible_path = root / 'docs/FINAL_HORROR_GAME_CONTENT.md'
bible = bible_path.read_text(encoding='utf-8')
# Keep the anonymous author's doubt, then finish with the requested canonical lines.
bible = bible.replace(
    "  > Forgive me, if you’re reading this.\n  >\n  > It has to be someone.\n  >\n  > I am no longer certain that the second sentence is true.",
    "  > I am no longer certain that the second sentence is true.\n  >\n  > Forgive me, if you're reading this.\n  > It has to be someone.")
bodies = {}
for block in bible.split('OBJECT NAME: '):
    match = re.search(r'`(?:ground|upper|basement|roots|echoes)/(vantree_\d+)`', block.split('\n')[0])
    if not match or '**Authored complete first-person letter:**' not in block:
        continue
    lines = re.findall(r'^  >(?: (.*))?$', block, re.M)
    bodies[match[1]] = '\n'.join(lines).strip()
assert len(bodies) == 13, f'Expected 13 authored bodies, found {len(bodies)}'
assert bodies['vantree_13'].endswith("Forgive me, if you're reading this.\nIt has to be someone.")
layout_path = root / 'data/estate_layout.json'
layout = layout_path.read_text(encoding='utf-8')
for ident, body in bodies.items():
    pattern = r'(^[^\n]*"' + ident + r'"[^\n]*$)'
    def replace_line(match):
        return re.sub(r'"text": "(?:\\.|[^"\\])*"', lambda _: '"text": ' + json.dumps(body, ensure_ascii=False), match[0])
    layout, count = re.subn(pattern, replace_line, layout, flags=re.M)
    assert count == 1, ident
layout_path.write_text(layout, encoding='utf-8')
bible = bible.replace('The complete first-person body below is authored expansion for this document.', 'The complete first-person body below is integrated in the runtime paging reader.')
bible = re.sub(r'Current complete runtime text: “[^”]*”\.', 'The complete first-person body below is shown by the animated parchment reader.', bible)
bible_path.write_text(bible, encoding='utf-8')
print(f'Integrated {len(bodies)} complete letters; IDs and positions retained.')
