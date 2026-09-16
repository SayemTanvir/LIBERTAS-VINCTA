"""Route demo-only placeholder characters to Godot's fallback font.

Retains the supplied font's outlines, names and license metadata unchanged.
Only the cmap is restricted to its usable English lettering and space; no
missing commercial glyphs are recovered or generated. Original TTF is retained.
Uses the standard library to rebuild the SFNT table directory and checksums.
"""
from pathlib import Path
import struct

folder = Path(__file__).resolve().parents[2] / "assets/fonts/horror_comics_demo"
source = (folder / "HorrorComicsDemoRegular.ttf").read_bytes()
u16 = lambda data, offset: struct.unpack_from(">H", data, offset)[0]
tables = {}
for i in range(u16(source, 4)):
    tag, _, offset, size = struct.unpack_from(">4sIII", source, 12 + i * 16)
    tables[tag] = source[offset:offset + size]
cmap = tables[b"cmap"]
for i in range(u16(cmap, 2)):
    platform, encoding, offset = struct.unpack_from(">HHI", cmap, 4 + i * 8)
    if platform in (0, 3) and u16(cmap, offset) == 4:
        mapping = cmap[offset:]
        break
else:
    raise ValueError("Expected Unicode format-4 cmap in supplied demo font")

count = u16(mapping, 6) // 2
ends, starts = 14, 16 + count * 2
deltas, ranges = starts + count * 2, starts + count * 4

def glyph(codepoint):
    for i in range(count):
        lo, hi = u16(mapping, starts + 2*i), u16(mapping, ends + 2*i)
        if lo <= codepoint <= hi:
            delta, span = u16(mapping, deltas + 2*i), u16(mapping, ranges + 2*i)
            if span == 0:
                return (codepoint + delta) & 0xffff
            value = u16(mapping, ranges + 2*i + span + 2*(codepoint-lo))
            return (value + delta) & 0xffff if value else 0
    return 0

codes = [32, *range(65, 91), *range(97, 123), 0xffff]
size = len(codes)
power = size.bit_length() - 1
words = lambda values: struct.pack(">" + "H" * len(values), *values)
table = words([4, 16 + size*8, 0, size*2, 2*(2**power), power, size*2-2*(2**power)])
table += words(codes) + words([0]) + words(codes)
table += words([(glyph(cp)-cp) & 0xffff if cp != 0xffff else 1 for cp in codes])
table += words([0] * size)
tables[b"cmap"] = struct.pack(">HHHHIHHI", 0, 2, 0, 3, 20, 3, 1, 20) + table
head = bytearray(tables[b"head"])
head[8:12] = bytes(4)
tables[b"head"] = bytes(head)

def checksum(data):
    data += bytes((-len(data)) % 4)
    return sum(struct.unpack(">" + "I"*(len(data)//4), data)) & 0xffffffff

directory, payload = bytearray(), bytearray()
head_offset = 0
for tag, data in sorted(tables.items()):
    offset = 12 + len(tables)*16 + len(payload)
    directory += struct.pack(">4sIII", tag, checksum(data), offset, len(data))
    if tag == b"head":
        head_offset = offset
    payload += data + bytes((-len(data)) % 4)
result = bytearray(source[:12]) + directory + payload
struct.pack_into(">I", result, head_offset+8, (0xb1b0afba-checksum(bytes(result))) & 0xffffffff)
assert checksum(bytes(result)) == 0xb1b0afba
(folder / "HorrorComicsDemoMenuLetters.ttf").write_bytes(result)
print("Prepared menu lettering font; original outlines and licensing metadata retained.")
