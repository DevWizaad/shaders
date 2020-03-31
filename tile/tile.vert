/**
 *  \file tile.vert
 *
 *  This collection of shaders will render tiles for a specific tilesheet.
 *  The shader is expected to be invoked as GL_POINTS, because a single location is input
 *  instead of a list of verticies. The geometry shader will then take care of transforming
 *  the world-space Transform data into a list of screen-space verticies.
 *
 *  Terminology:
 *  Tilesheet: A texture containing a 2D grid of smaller, equally sized texture tiles.
 *  Tile: An identifier to a tile in a tilesheet.
 *
 *  Included Shaders:
 *  Vertex: tile.vert
 *  Geometry: tile.geom
 *  Fragment: tile.frag
 *
 *  Program Inputs:
 *  (location 0) ivec2 tile:          A buffer of which tiles in the tilesheet to render.
 *  (location 1) vec2 transformPos:   A buffer of world-space positions for each tile.
 *  (location 2) vec2 transformScale: A buffer of scales for each tile.
 *  (location 3) int transformRot:    A buffer of u16 rotations for each tile.
 *  uniform ivec2 tilesheetSize:      The size of the tilesheet as [w, h], in tiles.
 *  uniform sampler2D tilesheet:      The texture unit of the tilesheet.
 *  uniform mat3 worldToScreen:       The affine matrix that transforms points in world-space to screen-space.
 *
 *  Program Outputs:
 *  (location 0) vec4 fragColor: The rendered color for each fragment.
 *
 *  This vertex shader is simply a passthrough so we can do all the logic in the geometry shader.
 */
#version 330 core
layout (location = 0) in ivec2 tile;
layout (location = 1) in vec2 transformPos;
layout (location = 2) in vec2 transformScale;
layout (location = 3) in int transformRot;

out vec2 vertTile;
out vec2 vertPosition;
out vec2 vertScale;
out int vertRotation;

void main()
{
  vertTile = tile; // Implicit conversion from ivec2 to vec2.
  vertPosition = transformPos;
  vertScale = transformScale;
  vertRotation = transformRot;
}
