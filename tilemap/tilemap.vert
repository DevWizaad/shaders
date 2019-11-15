/**
 *  \file tilemap.vert
 *
 *  This collection of shaders will render a list of tiles with a cooresponding
 *  list of tile IDs. The simplest way to invoke the program is with the following function:
 *  glDrawArrays(GL_POINTS, 0, numTilesToRender);
 *
 *  Terminology:
 *  Tile-Space: The 2D integer coordinate plane used to define the location of tiles.
 *  Tilesheet: A texture containing a 2D grid of smaller, equally sized texture tiles.
 *  Tile Position: A ivec2 position in tile-space of a tile.
 *  Tile ID: An identifier to a tile in a tilesheet.
 *  Tilemap: A list of tile positions and their cooresponding tile IDs.
 *
 *  Program Inputs:
 *  (location 0) ivec2 tilePos:  A buffer of tile positions to render.
 *  (location 1) ivec2 tileID:   A buffer of tile IDs for each tile position.
 *  uniform ivec2 tilesheetSize: The size of the tilesheet as [w, h], in tiles.
 *  uniform sampler2D tilesheet: The texture unit of the tilesheet.
 *  uniform mat3 tileToScreen:   The affine matrix that transforms points in tile-space to screen-space.
 *
 *  Program Outputs:
 *  (location 0) vec4 fragColor: The rendered color for each fragment.
 *
 *  This vertex shader is simply a passthrough because the geometry shader will
 *  be splitting the tile positions into 4 vertices of the cooresponding square.
 *  It is possible to compress both tile positions and tile IDs to reduce the
 *  amount of data required to copy to the GPU. The vertex shader would then be
 *  responsible for decompressing and passing the data onto the geometry shader.
 */
#version 330 core
layout (location = 0) in ivec2 tilePos;
layout (location = 1) in ivec2 tileID;

out vec2 vertTilePos;
out vec2 vertTileID;

void main()
{
  // Implicitly convert from int to float.
  vertTilePos = tilePos;
  vertTileID = tileID;
}
