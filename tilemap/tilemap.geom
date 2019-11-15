/**
 *  \file tilemap.geom
 *
 *  The job of the geometry shader is to convert a single tile position into
 *  a triangle_strip of the corresponding square, and transform the tile ID
 *  into texture coordinates. Afterwards, the vertices will be converted from
 *  tile-space into screen-space.
 */
#version 330 core
layout(points) in;
layout(triangle_strip, max_vertices = 4) out;

in vec2 vertTilePos[];
in vec2 vertTileID[];
out vec2 texCoor;

uniform ivec2 tilesheetSize;
uniform mat3 tileToScreen;

void main()
{
  vec2 tilePos = vertTilePos[0];
  vec2 tileID = vertTileID[0];

  // Create the 4 verticies of the our square.
  vec2 tilespacePos[4];
  tilespacePos[0] = vec2(tilePos.x    , tilePos.y + 1); // Top-left.
  tilespacePos[1] = vec2(tilePos.x    , tilePos.y);     // Bottom-left.
  tilespacePos[2] = vec2(tilePos.x + 1, tilePos.y + 1); // Top-right.
  tilespacePos[3] = vec2(tilePos.x + 1, tilePos.y);     // Bottom-right.

  // Create texture coordinates for each vertex.
  vec2 textureCoords[4];
  float texLeft   = tileID.x / tilesheetSize.x;
  float texRight  = (tileID.x + 1) / tilesheetSize.x;
  float texTop    = tileID.y / tilesheetSize.y;
  float texBottom = (tileID.y + 1) / tilesheetSize.y;
  textureCoords[0] = vec2(texLeft,  texTop);
  textureCoords[1] = vec2(texLeft,  texBottom);
  textureCoords[2] = vec2(texRight, texTop);
  textureCoords[3] = vec2(texRight, texBottom);

  for (int i = 0; i < 4; ++i)
  {
    // Convert the tile-space vertices into screen-space.
    vec3 screenVert = tileToScreen * vec3(tilespacePos[i], 1);
    gl_Position = vec4(screenVert.x, screenVert.y, 0, 1);

    // Send texture coordinates to be interpolated for the fragment shader.
    texCoor = textureCoords[i];
    EmitVertex();
  }
  EndPrimitive();
}
