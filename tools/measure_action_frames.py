"""Read generated sheets and write Godot atlas/foot metadata. Never edits image pixels."""
import json
from pathlib import Path
from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / 'assets/sprites/player/actions'
NAMES = ['torch_use', 'torch_move', 'vent_enter', 'door_unlock', 'piano',
         'hide_wall', 'hide_table', 'bag_pickup', 'key_pickup']


def measure(name):
    image = Image.open(ASSETS / (name + '.png')).convert('RGBA')
    width, height = image.size
    pixels = list(image.getdata())
    mask = bytearray(a > 100 and min(r-g, b-g) < 85 for r,g,b,a in pixels)
    components = []
    for start in range(len(mask)):
        if not mask[start]:
            continue
        mask[start] = 0
        todo = [start]
        count = 0
        x0 = x1 = start % width
        y0 = y1 = start // width
        while todo:
            index = todo.pop()
            x, y = index % width, index // width
            count += 1
            x0, x1, y0, y1 = min(x0,x), max(x1,x), min(y0,y), max(y1,y)
            for nxt in (index-1 if x else -1, index+1 if x < width-1 else -1,
                        index-width if y else -1, index+width if y < height-1 else -1):
                if nxt >= 0 and mask[nxt]:
                    mask[nxt] = 0
                    todo.append(nxt)
        if count > 8:
            components.append([count, x0, y0, x1+1, y1+1])
    columns = 8 if name == 'torch_move' else 6
    # The largest connected silhouettes are bodies; small detached keys/bags join later.
    bodies = sorted(components, reverse=True)[:columns*4]
    assert min(b[0] for b in bodies) > 1500, (name, bodies)
    bodies.sort(key=lambda b:b[4])
    result = {'texture': 'res://assets/sprites/player/actions/'+name+'.png',
              'size': [width,height], 'rows': []}
    for row_index in range(4):
        row = sorted(bodies[row_index*columns:(row_index+1)*columns], key=lambda b:b[1]+b[3])
        standing_height = row[0][4] - row[0][2]
        row_result = {'scale': round(69.0/standing_height, 6), 'frames': []}
        for body in row:
            _, left, top, right, bottom = body
            root_x = (left+right)/2
            # Boots provide a stable foot anchor for planted actions, even with a reaching arm.
            boots = []
            for y in range(max(top, bottom-max(8,standing_height//9)),bottom):
                for x in range(left,right):
                    r,g,b,a = pixels[y*width+x]
                    if a>100 and r>g+15 and b>g*1.12 and r>b*0.9 and min(r-g,b-g)<85:
                        boots.append(x)
            if boots and name not in ['vent_enter', 'hide_table', 'torch_move']:
                root_x = (min(boots)+max(boots)+1)/2
            for component in components:
                if component in bodies:
                    continue
                _, x0,y0,x1,y1 = component
                cx, cy = (x0+x1)/2,(y0+y1)/2
                nearest = min(bodies, key=lambda item:
                    max(item[1]-cx, 0, cx-item[3])**2 + max(item[2]-cy, 0, cy-item[4])**2)
                if nearest == body and max(left-cx,0,cx-right)<35 and max(top-cy,0,cy-bottom)<20:
                    left,top,right,bottom=min(left,x0),min(top,y0),max(right,x1),max(bottom,y1)
            left,top,right,bottom=max(0,left-2),max(0,top-2),min(width,right+2),min(height,bottom+2)
            w,h=right-left,bottom-top
            row_result['frames'].append({'rect':[left,top,w,h],
                'offset':[round(w/2-(root_x-left),2), round(h/2-(body[4]-top),2)]})
        result['rows'].append(row_result)
    print(name, image.size, 'scales', [r['scale'] for r in result['rows']])
    return result


if __name__ == '__main__':
    available = [name for name in NAMES if (ASSETS / (name + '.png')).is_file()]
    missing = sorted(set(NAMES) - set(available))
    if missing:
        print('Optional sheets absent (runtime uses existing poses):', ', '.join(missing))
    metadata = {name: measure(name) for name in available}
    if not metadata:
        raise RuntimeError('No action sheets found; preserving the existing manifest')
    destination = ASSETS / 'frames.json'
    temporary = destination.with_suffix('.json.tmp')
    temporary.write_text(json.dumps(metadata, indent=2)+'\n', encoding='utf-8')
    temporary.replace(destination)
