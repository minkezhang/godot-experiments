# Isometric Map

https://user-images.githubusercontent.com/3048682/236655920-3506fe63-707b-4de0-9a56-9127a5e35cb4.mp4


The layout, collision hitboxes, and navigation layers are / will be all
contained in the Base TileMap layer. This TileMap is used to generate the
isometric view managed by the Render TileMap.

An additional Highlight TileMap UI layer is also included, which affords
the ability to add more user-driven sprites to the scene.

The Mask TileMap is an artifact to load a mouse colilsion TileSet.

Developers should only edit the Base TileMap.

N.B.: The Base to Render TileMap generation logic is a personal quirk and
does not need to be implemented for the isometric tile selection.

There are four tilesets to keep synced (i.e. keep source and atlas
coordinates identical).

1. base.png is the layout tileset and is used to generate the isometric view.
   Sprites here are representations of each rendered tile (they may as well
   be text strings).
2. render.png is the actual sprites seen by the player. Each sprite is a
   64 x 64 square, and is meant to be used in a 64 x 32 isometric TileMap.
   The code is (should be) size-agnostic.
3. mask.png is an overlay on top of each corresponding sprite in render.png
   and is used to detect mouse collisions with the render.png sprites. Each
   mask consists of three colors --
   1. WHITE for a successful mouse collision (i.e. the sprite should be
      selected.
   2. BLACK for a failed mouse collision (i.e. the sprite was targeted, but
      should not be selected for some reason).
   3. TRANSPARENT for an indeterminate collision result -- the current sprite
      has not been touched, and collision detection should move onto the
      tile beneath the current one.
4. highlight.png is a simple set of sprites used for indicating which tiles
   are being selected.

The basic algorithm is as follows --

1. Calculate the apparent cell being selected (i.e. a simple local_to_map
   call on the Render TileMap).
2. Calculate the apparent neighboring cell coordinates -- a cursor hovering
   over a specific cell may be hovering over that cell, or the user may mean
   to hover over the bottom half of the cell above, etc.
3. Calculate the actual tiles being selected and re-order in reverse render
   order (see _get_raytrace_stack).
4. For each tile in the stack, check for mouse collisions against the mouse
   position. The way we check for collisions here is by using a mask, but
   fancier math may also be used.
5. Choose the first tile which produces a hit in this manner.

Multi-cell tiles (e.g. large buildings) may be detected in the same manner,
but would mean step 2 above will have to expand to consider all tiles in the
largest building. This may incur too heavy a penalty, and you may wish to
consider alternative methods.

## Acknowledgements

* discussions with [Clint Bellanger](https://github.com/clintbellanger)
