# Known issues

No gameplay-blocking issue is currently known in the maintained automated routes.

Rendered Windows capture runs intermittently return native access-violation status `0xC0000005` during shutdown, after completing their checks and screenshots. A repeated focused capture run, the normal menu, and the opening-scene smoke test exited cleanly. No GDScript error or in-game reproduction was observed; the cause remains unconfirmed. See `docs/GAMEPLAY_POLISH_REPORT.md`.

Before public release, confirm the source license and required attribution for `assets/environment/props/music_room/piano1.png`, the supplied zombie sprites, and the supplied footstep recordings. Windows and Web export templates are not bundled with the repository and must match the installed Godot 4.7 version.
