# Horror Comics Demo

Imported from the user-supplied `horrorcomicsdemo.zip` on 17 September 2026.

- Font: `HorrorComicsDemoRegular.ttf`
- Original license notice: [LICENSE.txt](LICENSE.txt), marked personal-use demo.
- Used for intro and menu body text/buttons. Titles use Horroroid.
- Gameplay HUD, letters, speech and narration retain their existing fonts.

The original font and license are copied without modifying their contents.

`HorrorComicsDemoMenuLetters.ttf` retains the original outlines, names and license
metadata, with a character map restricted to usable English letters and spaces.
The supplied demo draws placeholder symbols for numerals and punctuation. This
menu-only version allows those characters to use the existing Georgia/Times
fallback instead, keeping percentages, resolutions and key hints readable.
No missing glyphs are reconstructed. Regenerate with
`python scripts/tools/prepare_menu_font.py`.
